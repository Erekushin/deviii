import 'dart:convert';
import 'dart:developer';

import 'package:devita/helpers/gvariables.dart';
import 'package:devita/model/messeges_model.dart';
import 'package:devita/screens/chat/chat_room.dart';
import 'package:devita/screens/home/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ion/flutter_ion.dart' as ion;
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';

import 'package:flutter_webrtc/flutter_webrtc.dart';

class ViewVideoController extends GetxController {
  var host = 'wss://pion.gerege.mn:7000/session/';

  final videoRenderers = Rx<List<VideoRendererAdapter>>([]);
  final _cameraOff = false.obs;
  final _microphoneOff = false.obs;
  final _speakerOn = true.obs;
  GlobalKey<ScaffoldState>? _scaffoldkey;
  var name = ''.obs;
  var room = ''.obs;
  final String _uuid = const Uuid().v4();
  ion.LocalStream? localStream;
  ion.Client? client;
  late final String selectedId;
  late final String selectedName;

  // var messageChannel;

  connectNewVideo(roomId, roomName) async {
    GlobalVariables.roomID = roomId;
    room.value = roomId;
    name.value = roomName;
    print('connectionId: $roomId +  $roomName');
    final signalClient = ion.JsonRPCSignal(host + roomId);

    /// init sfu  clients
    client = await ion.Client.create(
      sid: room.value,
      uid: _uuid,
      signal: signalClient,
      // config: configCustom
    );

    client?.ontrack = (track, ion.RemoteStream stream) async {
      track.onEnded = () {
        log('sda remove');
        print('sda remove');
      };

      if (track.kind == "video") {
        // track != null &&
        stream.preferLayer!(ion.Layer.medium);
        _addAdapter(
          await VideoRendererAdapter.create(
            stream.id,
            stream.stream,
            false,
          ),
        );
        stream.stream.onRemoveTrack = (val) {
          print('sda we: $val');
        };
      }
    };

    // var resolution = 'hd';
    var codec = 'vp8';
    localStream = await ion.LocalStream.getUserMedia(
        constraints: ion.Constraints.defaults
          ..simulcast = false
          ..codec = codec);

    _addAdapter(await VideoRendererAdapter.create(
        localStream!.stream.id, localStream!.stream, true));
    client?.publish(localStream!);

    // create a datachannel
    var dataChannel = client?.createDataChannel("data");
    dataChannel!.then((data) {
      GlobalVariables.sendData = data;

      data.onMessage = (val) {
        var recieveMessage = jsonDecode(val.text);
        print("messageType: ${recieveMessage['type']}");
        if (recieveMessage['type'] == "remove") {
          print('typeremove: ${recieveMessage['type']}');
          _cleanUp();
        }
        GlobalVariables.messageListAll.insert(
          0,
          MessageData(
            recieveMessage['type'],
            recieveMessage['user_id'],
            recieveMessage['emp_id'],
            recieveMessage['sender_type'],
            recieveMessage['txt'],
          ),
        );
        // print('scorll down call');
        GlobalVariables.scrollDown();
      };
    });
  }

  _addAdapter(VideoRendererAdapter adapter) {
    videoRenderers.value.add(adapter);
    videoRenderers.update((val) {});
  }

  _swapAdapter(adapter) {
    var index = videoRenderers.value
        .indexWhere((element) => element.mid == adapter.mid);
    if (index != -1) {
      var temp = videoRenderers.value.elementAt(index);
      videoRenderers.value[0] = videoRenderers.value[index];
      videoRenderers.value[index] = temp;
    }
  }

  //Switch speaker/earpiece
  _switchSpeaker() {
    if (_localVideo != null) {
      _speakerOn.value = !_speakerOn.value;
      MediaStreamTrack audioTrack = _localVideo!.stream.getAudioTracks()[0];
      audioTrack.enableSpeakerphone(_speakerOn.value);
      _showSnackBar(":::Switch to " +
          (_speakerOn.value ? "speaker" : "earpiece") +
          ":::");
    }
  }

  VideoRendererAdapter? get _localVideo {
    VideoRendererAdapter? renderrer;
    for (var element in videoRenderers.value) {
      if (element.local) {
        renderrer = element;
      }
    }
    return renderrer;
  }

  List<VideoRendererAdapter> get _remoteVideos {
    List<VideoRendererAdapter> renderers = ([]);
    for (var element in videoRenderers.value) {
      if (!element.local) {
        renderers.add(element);
      }
    }
    return renderers;
  }

  //Switch local camera
  _switchCamera() {
    if (_localVideo != null &&
        _localVideo!.stream.getVideoTracks().isNotEmpty) {
      _localVideo?.stream.getVideoTracks()[0].switchCamera();
    } else {
      _showSnackBar(":::Unable to switch the camera:::");
    }
  }

  //Open or close local video
  _turnCamera() {
    if (_localVideo != null &&
        _localVideo!.stream.getVideoTracks().isNotEmpty) {
      var muted = !_cameraOff.value;
      _cameraOff.value = muted;
      _localVideo?.stream.getVideoTracks()[0].enabled = !muted;
    } else {
      _showSnackBar(":::Unable to operate the camera:::");
    }
  }

  //Open or close local audio
  _turnMicrophone() {
    if (_localVideo != null &&
        _localVideo!.stream.getAudioTracks().isNotEmpty) {
      var muted = !_microphoneOff.value;
      _microphoneOff.value = muted;
      _localVideo?.stream.getAudioTracks()[0].enabled = !muted;
      _showSnackBar(":::The microphone is ${muted ? 'muted' : 'unmuted'}:::");
    } else {}
  }

  _cleanUp() async {
    if (_localVideo != null) {
      await localStream!.unpublish();
    }
    for (var item in videoRenderers.value) {
      var stream = item.stream;
      try {
        client?.close();
        await stream.dispose();
      } catch (error) {
        return null;
      }
    }
    videoRenderers.value.clear();
    Get.back();
  }

  _showSnackBar(String message) {
    _scaffoldkey?.currentState!.showSnackBar(SnackBar(
      content: Container(
        //color: Colors.white,
        decoration: BoxDecoration(
            color: Colors.black38,
            border: Border.all(width: 2.0, color: Colors.black),
            borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.fromLTRB(45, 0, 45, 45),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(message,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center),
        ),
      ),
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(
        milliseconds: 1000,
      ),
    ));
  }
}

class VideoRendererAdapter {
  String mid;
  bool local;
  RTCVideoRenderer? renderer;
  MediaStream stream;
  RTCVideoViewObjectFit _objectFit =
      RTCVideoViewObjectFit.RTCVideoViewObjectFitCover;

  VideoRendererAdapter._internal(this.mid, this.stream, this.local);

  static Future<VideoRendererAdapter> create(
      String mid, MediaStream stream, bool local) async {
    var renderer = VideoRendererAdapter._internal(mid, stream, local);
    await renderer.setupSrcObject();
    return renderer;
  }

  setupSrcObject() async {
    if (renderer == null) {
      renderer = RTCVideoRenderer();
      await renderer?.initialize();
    }
    renderer?.srcObject = stream;
    if (local) {
      _objectFit = RTCVideoViewObjectFit.RTCVideoViewObjectFitCover;
    }
  }

  switchObjFit() {
    _objectFit =
        (_objectFit == RTCVideoViewObjectFit.RTCVideoViewObjectFitContain)
            ? RTCVideoViewObjectFit.RTCVideoViewObjectFitCover
            : RTCVideoViewObjectFit.RTCVideoViewObjectFitContain;
  }

  RTCVideoViewObjectFit get objFit => _objectFit;

  set objectFit(RTCVideoViewObjectFit objectFit) {
    _objectFit = objectFit;
  }

  dispose() async {
    if (renderer != null) {
      renderer?.srcObject = null;
      await renderer?.dispose();
      renderer = null;
    }
  }
}

class BoxSize {
  BoxSize({required this.width, required this.height});

  double width;
  double height;
}

class MeetingViewNew extends GetView<ViewVideoController> {
  const MeetingViewNew({Key? key}) : super(key: key);
  List<VideoRendererAdapter> get remoteVideos => controller._remoteVideos;
  VideoRendererAdapter? get localVideo => controller._localVideo;

  final double localWidth = 114.0;
  final double localHeight = 72.0;
  BoxSize localVideoBoxSize(Orientation orientation) {
    return BoxSize(
      width: (orientation == Orientation.portrait) ? localHeight : localWidth,
      height: (orientation == Orientation.portrait) ? localWidth : localHeight,
    );
  }

  Widget _buildMajorVideo() {
    return Obx(() {
      if (remoteVideos.isEmpty) {
        return Image.asset(
          'assets/images/loading.jpeg',
          fit: BoxFit.cover,
        );
      }
      var adapter = remoteVideos[0];
      return GestureDetector(
          onDoubleTap: () {
            adapter.switchObjFit();
          },
          child: RTCVideoView(adapter.renderer!,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain));
    });
  }

  Widget _buildVideoList() {
    return Obx(() {
      if (remoteVideos.length <= 1) {
        return Container();
      }
      return ListView(
          scrollDirection: Axis.horizontal,
          children:
              remoteVideos.getRange(1, remoteVideos.length).map((adapter) {
            adapter.objectFit =
                RTCVideoViewObjectFit.RTCVideoViewObjectFitCover;
            return _buildMinorVideo(adapter);
          }).toList());
    });
  }

  Widget _buildLocalVideo(Orientation orientation) {
    return Obx(() {
      if (localVideo == null) {
        return Container();
      }
      var size = localVideoBoxSize(orientation);
      return SizedBox(
          width: size.width,
          height: size.height,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black87,
              border: Border.all(
                color: Colors.white,
                width: 0.5,
              ),
            ),
            child: GestureDetector(
                onTap: () {
                  controller._switchCamera();
                },
                onDoubleTap: () {
                  localVideo?.switchObjFit();
                },
                child: RTCVideoView(localVideo!.renderer!,
                    objectFit: localVideo!.objFit)),
          ));
    });
  }

  Widget _buildMinorVideo(VideoRendererAdapter adapter) {
    return SizedBox(
      width: 120,
      height: 90,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black87,
          border: Border.all(
            color: Colors.white,
            width: 1.0,
          ),
        ),
        child: GestureDetector(
            onTap: () => controller._swapAdapter(adapter),
            onDoubleTap: () => adapter.switchObjFit(),
            child: RTCVideoView(adapter.renderer!, objectFit: adapter.objFit)),
      ),
    );
  }

  //Leave current video room

  Widget _buildLoading() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Холболт уншиж байна...',
            style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  //tools
  List<Widget> _buildTools(BuildContext context) {
    return <Widget>[
      SizedBox(
        width: 36,
        height: 36,
        child: RawMaterialButton(
          shape: const CircleBorder(
            side: BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
          child: Obx(() => Icon(
                controller._cameraOff.value
                    ? Icons.video_call_sharp
                    : Icons.video_call,
                color: controller._cameraOff.value ? Colors.red : Colors.white,
              )),
          onPressed: controller._turnCamera,
        ),
      ),
      SizedBox(
        width: 36,
        height: 36,
        child: RawMaterialButton(
          shape: const CircleBorder(
            side: BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
          child: const Icon(
            Icons.video_camera_back,
            color: Colors.white,
          ),
          onPressed: controller._switchCamera,
        ),
      ),
      SizedBox(
        width: 36,
        height: 36,
        child: RawMaterialButton(
          shape: const CircleBorder(
            side: BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
          child: Obx(() => Icon(
                controller._microphoneOff.value
                    ? Icons.mic
                    : Icons.mic_external_off,
                color:
                    controller._microphoneOff.value ? Colors.red : Colors.white,
              )),
          onPressed: controller._turnMicrophone,
        ),
      ),
      SizedBox(
        width: 36,
        height: 36,
        child: RawMaterialButton(
          shape: const CircleBorder(
            side: BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
          child: Obx(() => Icon(
                controller._speakerOn.value
                    ? Icons.volume_down
                    : Icons.speaker_notes_off,
                color: Colors.white,
              )),
          onPressed: controller._switchSpeaker,
        ),
      ),
      SizedBox(
        width: 36,
        height: 36,
        child: RawMaterialButton(
          shape: const CircleBorder(
            side: BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
          child: const Icon(
            Icons.phone_disabled,
            color: Colors.red,
          ),
          onPressed: () {
            Get.dialog(AlertDialog(
                title: const Text("Hangup"),
                content: const Text("Are you sure to leave the room?"),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  TextButton(
                    child: const Text(
                      "Hangup",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Get.back();
                      controller._cleanUp();
                    },
                  )
                ]));
          },
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return SafeArea(
        child: Scaffold(
            key: controller._scaffoldkey,
            body: Container(
              color: Colors.black87,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      color: Colors.black54,
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Container(
                              child: _buildMajorVideo(),
                            ),
                          ),
                          Positioned(
                            right: 10,
                            top: 90,
                            child: Container(
                              child: _buildLocalVideo(orientation),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 48,
                            height: 90,
                            child: Container(
                              margin: const EdgeInsets.all(6.0),
                              child: _buildVideoList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Obx(() =>
                      (remoteVideos.isEmpty) ? _buildLoading() : Container()),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 48,
                    child: Stack(
                      children: <Widget>[
                        Opacity(
                          opacity: 0.5,
                          child: Container(
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          height: 48,
                          margin: const EdgeInsets.all(0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: _buildTools(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 20,
                    height: 48,
                    child: Stack(
                      children: <Widget>[
                        Opacity(
                          opacity: 0.5,
                          child: Container(
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(0.0),
                          child: Center(
                            child: Text(
                              GlobalVariables.selectedRoomName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(
                              Icons.chat_bubble_outline,
                              size: 28.0,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              // Get.back();

                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  enableDrag: false,
                                  builder: (context) {
                                    return Container(
                                      margin: const EdgeInsets.only(top: 30),
                                      height: GlobalVariables.gHeight,
                                      child: const ChatRoom(),
                                    );
                                  });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
      );
    });
  }
}
