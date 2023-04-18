import 'dart:convert';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/model/messeges_model.dart';
import 'package:devita/screens/chat/own_message_card.dart';
import 'package:devita/screens/chat/reply_message_card.dart';
import 'package:devita/screens/chat/videoCall/video_chat.dart';
import 'package:devita/services/services.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:devita/helpers/gextensions.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  var textMessageController = TextEditingController();
  bool sendButton = false;
  XFile? imageSend;
  final ImagePicker _picker = ImagePicker();
  bool show = false;
  FocusNode focusNode = FocusNode();
  bool test = false;
  List chatHistory = [];
  String imageDoctor = '';
  final viewVideoController = Get.find<ViewVideoController>();

  _videoUpload() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    setState(() {
      // imageSend = image;
      print("LOLO ${video?.path}");
      if (video?.path != null) {
        // uploadProfile(imageSend?.path);
        print('imageSend?.path: ${video?.path}');
        uploadImageServer(video?.path, 'video');
      }
    });
  }

  _imgFromCameraProfile() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    setState(() {
      imageSend = image;
      if (imageSend?.path != null) {
        // uploadProfile(imageSend?.path);
        print('imageSend?.path: ${imageSend?.path}');
        uploadImageServer(imageSend?.path, 'image');
      }
    });
  }

  _imgFromGalleryProfile() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    setState(() {
      imageSend = image;
      if (imageSend?.path != null) {
        print('imageSend?.path: ${imageSend?.path}');
        uploadImageServer(imageSend?.path, 'image');
      }
    });
  }

  void _showPickerProfile(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: Text(
                      'r101335'.coreTranslationWord(),
                    ),
                    onTap: () {
                      _imgFromGalleryProfile();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: Text(
                    'r101336'.coreTranslationWord(),
                  ),
                  onTap: () {
                    _imgFromCameraProfile();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  uploadImageServer(filepath, type) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse(CoreUrl.baseUrl + 'file/file/upload'));
    request.files.add(await http.MultipartFile.fromPath('file', filepath));
    var res = await request.send();
    var bodyResponse = await res.stream.bytesToString(); // response body
    var resValue = json.decode(bodyResponse);
    print('responseuploadImageServer: ${resValue['result']['name']}');
    setState(() {
      if (type == 'video') {
        var message = {
          "type": "video",
          "user_id": GlobalVariables.id,
          "emp_id": GlobalVariables.employId,
          "sender_type": "user",
          "txt": resValue['result']['name'],
        };
        GlobalVariables.sendData
            .send(RTCDataChannelMessage(json.encode(message)));
        GlobalVariables.messageListAll.insert(
          0,
          MessageData(
            'video',
            GlobalVariables.id,
            GlobalVariables.employId,
            'user',
            resValue['result']['name'],
          ),
        );
        GlobalVariables.scrollDown();
      } else {
        var message = {
          "type": "image",
          "user_id": GlobalVariables.id,
          "emp_id": GlobalVariables.employId,
          "sender_type": "user",
          "txt": resValue['result']['name'],
        };
        GlobalVariables.sendData
            .send(RTCDataChannelMessage(json.encode(message)));
        GlobalVariables.messageListAll.insert(
          0,
          MessageData(
            'image',
            GlobalVariables.id,
            GlobalVariables.employId,
            'user',
            resValue['result']['name'],
          ),
        );
        GlobalVariables.scrollDown();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getChatHistory();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
  }

  getChatHistory() {
    GlobalVariables.messageListAll = <MessageData>[].obs;
    print('resssssssssss10: ${GlobalVariables.messageListAll.length}');
    var bodyData = {
      "user_id": GlobalVariables.id,
      "emp_id": GlobalVariables.employId,
    };
    Services()
        .postRequest(json.encode(bodyData), CoreUrl.chatHistory, true)
        .then((data) {
      var res = json.decode(data.body);
      setState(() {
        print('yronhiii: ${res['result']['emp']['profile_img']}');
        if (res['result']['emp']['profile_img'] != '') {
          imageDoctor = res['result']['emp']['profile_img'];
        }
        chatHistory = res['result']['chats'];

        chatHistory.forEach((element) {
          print('resssssssssss: $element');
          GlobalVariables.messageListAll.add(
            MessageData(
              element['msg_type'],
              GlobalVariables.id,
              GlobalVariables.employId,
              element['sender_type'],
              element['txt'],
            ),
          );
        });
        GlobalVariables.scrollDown();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: AppBar(
              backgroundColor: CoreColor().backgroundContainer,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: CoreColor().appGreen,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Column(
                children: [
                  Text(
                    GlobalVariables.selectedRoomName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Online now',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: CoreColor().appGreen),
                  )
                ],
              ),
              titleSpacing: 0,
              centerTitle: true,
              elevation: 0,
            ),
          ),
          body: SizedBox(
            height: GlobalVariables.gHeight,
            width: GlobalVariables.gWidth,
            child: WillPopScope(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Obx(
                      () => ListView.builder(
                        controller: GlobalVariables.scrollController,
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: GlobalVariables.messageListAll.length + 1,
                        itemBuilder: (context, index) {
                          if (index == GlobalVariables.messageListAll.length) {
                            return Container(
                              height: 0,
                            );
                          }
                          return
                              // GlobalVariables
                              //             .messageListAll[index].senderType ==
                              //         "profile"
                              //     ? Column(
                              //         children: [
                              //           const SizedBox(height: 20),
                              //           ClipRRect(
                              //             borderRadius: BorderRadius.circular(50.0),
                              //             child: Image.asset(
                              //               'assets/images/userprofile.png',
                              //               width: 100,
                              //               height: 100,
                              //               fit: BoxFit.cover,
                              //             ),
                              //           ),
                              //           const SizedBox(height: 5),
                              //           Text(
                              //             GlobalVariables
                              //                 .messageListAll[index].senderType,
                              //             style: const TextStyle(
                              //               color: Colors.white,
                              //               fontWeight: FontWeight.bold,
                              //               fontSize: 18,
                              //             ),
                              //           ),
                              //           const SizedBox(height: 20),
                              //           Row(
                              //             children: [
                              //               Expanded(
                              //                 child: Container(
                              //                   height: 1,
                              //                   color:
                              //                       Colors.white.withOpacity(0.3),
                              //                 ),
                              //               ),
                              //               Container(
                              //                 padding: const EdgeInsets.only(
                              //                     left: 5, right: 5),
                              //                 child: Text(
                              //                   GlobalVariables
                              //                       .messageListAll[index].txt,
                              //                   style: TextStyle(
                              //                     color:
                              //                         Colors.white.withOpacity(0.3),
                              //                   ),
                              //                 ),
                              //               ),
                              //               Expanded(
                              //                 child: Container(
                              //                   height: 1,
                              //                   color:
                              //                       Colors.white.withOpacity(0.3),
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //           const SizedBox(height: 30)
                              //         ],
                              //       )
                              // :
                              GlobalVariables
                                          .messageListAll[index].senderType !=
                                      "employee"
                                  ? Container(
                                      margin: const EdgeInsets.only(right: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          MessageCard(
                                            message: GlobalVariables
                                                .messageListAll[index].txt
                                                .toString(),
                                            typeMessage: GlobalVariables
                                                .messageListAll[index].type,
                                          ),
                                          GlobalVariables.messageListAll[index]
                                                      .type ==
                                                  'remove'
                                              ? Container()
                                              : Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 5),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.0),
                                                    child: Image.network(
                                                      CoreUrl.imageUrl +
                                                          GlobalVariables
                                                              .profileImage,
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.only(left: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          GlobalVariables.messageListAll[index]
                                                      .type ==
                                                  'remove'
                                              ? Container()
                                              : imageDoctor == ''
                                                  ? Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 5),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50.0),
                                                        child: Image.asset(
                                                          'assets/images/telehealth.png',
                                                          width: 50,
                                                          height: 50,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 5),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50.0),
                                                        child: Image.network(
                                                          CoreUrl.imageUrl +
                                                              imageDoctor,
                                                          width: 50,
                                                          height: 50,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                          ReplyCard(
                                            message: GlobalVariables
                                                .messageListAll[index].txt
                                                .toString(),
                                            typeMessage: GlobalVariables
                                                .messageListAll[index].type,
                                          ),
                                        ],
                                      ),
                                    );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: GlobalVariables.gWidth - 60,
                              child: Card(
                                margin: const EdgeInsets.only(
                                    left: 2, right: 2, bottom: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: TextFormField(
                                  controller: textMessageController,
                                  textAlignVertical: TextAlignVertical.center,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                  minLines: 1,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      setState(() {
                                        sendButton = true;
                                      });
                                    } else {
                                      setState(() {
                                        sendButton = false;
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Type a message",
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                    prefixIcon: IconButton(
                                      icon: Icon(
                                        show
                                            ? Icons.keyboard
                                            : Icons.emoji_emotions_outlined,
                                      ),
                                      onPressed: () {
                                        if (!show) {
                                          focusNode.unfocus();
                                          focusNode.canRequestFocus = false;
                                        }
                                        setState(() {
                                          show = !show;
                                        });
                                      },
                                    ),
                                    suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                            icon: const Icon(Icons.attach_file),
                                            onPressed: () {
                                              setState(() {
                                                // openFileExplorer();
                                                _videoUpload();
                                              });
                                            }),
                                        IconButton(
                                          icon: const Icon(Icons.camera_alt),
                                          onPressed: () {
                                            setState(() {
                                              _showPickerProfile(context);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    contentPadding: const EdgeInsets.all(5),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 8,
                                right: 2,
                                left: 2,
                              ),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: CoreColor().oceanSurface,
                                child: IconButton(
                                  icon: Icon(
                                    sendButton
                                        ? Icons.send
                                        : test == true
                                            ? Icons.stop
                                            : Icons.mic,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      setState(() {
                                        if (textMessageController.text != '') {
                                          var message = {
                                            "type": "text",
                                            "user_id": GlobalVariables.id,
                                            "emp_id": GlobalVariables.employId,
                                            "sender_type": "user",
                                            "txt": textMessageController.text
                                                .trim(),
                                          };
                                          print(
                                              'nessage: ${json.encode(message)}');
                                          GlobalVariables.sendData.send(
                                              RTCDataChannelMessage(
                                                  json.encode(message)));
                                          GlobalVariables.messageListAll.insert(
                                            0,
                                            MessageData(
                                              'text',
                                              GlobalVariables.id,
                                              GlobalVariables.employId,
                                              'user',
                                              textMessageController.text,
                                            ),
                                          );
                                          GlobalVariables.scrollDown();
                                          textMessageController.clear();
                                        }
                                      });
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              onWillPop: () {
                if (show) {
                  setState(() {
                    show = false;
                  });
                } else {
                  Navigator.pop(context);
                }
                return Future.value(false);
              },
            ),
          ),
        )
      ],
    );
  }

  getFormatedDate(int now) {
    var date = DateTime.fromMillisecondsSinceEpoch(now);
    var formattedDate = DateFormat('hh:mm a').format(date);
    return formattedDate;
  }
}
