import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/screens/chat/videoCall/video_chat.dart';
import 'package:devita/screens/user_views/doctor/event.dart';
import 'package:devita/services/services.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<ChatPage> {
  final viewVideoController = Get.find<ViewVideoController>();

  List items = [];
  DateFormat timeFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
  late String timeNow;

  @override
  void initState() {
    timeNow = timeFormat.format(DateTime.now());
    super.initState();
    listData();
  }

  listData() {
    String startDate =
        DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    String endDate = DateFormat('yyyy-MM-dd')
        .format(DateTime(kToday.year, kToday.month + 1, 0))
        .toString();
    var bodyData = {
      "start_date": startDate,
      "end_date": endDate,
    };

    Services()
        .postRequest(json.encode(bodyData),
            'https://backend.devita.mn/calendar/user/order/list', true)
        .then((data) {
      var response = json.decode(data.body);
      print(response);
      setState(() {
        items = response['result']['items'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoreColor().backgroundNew,
      body: ListView.builder(
        itemBuilder: (con, index) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    var dateValue = DateFormat("yyyy-MM-ddTHH:mm:ss")
                        .parseUTC(items[index]['date_time']);
                    print(timeFormat.format(dateValue));
                    print(timeNow);

                    if (timeFormat.format(dateValue).compareTo(timeNow) == 0) {
                      print('true');
                      GlobalVariables.employId = items[index]['employee_id'];
                      GlobalVariables.doctorName =
                          items[index]['employee']['first_name'].toString() +
                              ' ' +
                              items[index]['employee']['last_name'].toString();
                      print('ene id mon uu: ${GlobalVariables.employId}');
                      viewVideoController.connectNewVideo(
                        items[index]['id'].toString(),
                        GlobalVariables.doctorName,
                      );
                      videoCallDisplay(index);
                    } else {
                      print('false');
                      errorModal();
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: CachedNetworkImage(
                              imageUrl: CoreUrl.imageUrl +
                                  items[index]['employee']['profile_img'],
                              fit: BoxFit.fitWidth,
                              width: 60,
                              height: 60,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Image.asset("assets/images/userprofile.png"),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // width: GlobalVariables.gWidth - 160,
                                child: Text(
                                  items[index]['employee']['first_name']
                                          .toString() +
                                      ' ' +
                                      items[index]['employee']['last_name']
                                          .toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Text(
                                items[index]['emp_cancel_description'],
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          Text(
                            time(items[index]['date_time']),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w100,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(color: Colors.grey, height: 2),
            ],
          );
        },
        itemCount: items.length,
        shrinkWrap: true,
        padding: const EdgeInsets.all(5),
        scrollDirection: Axis.vertical,
      ),
    );
  }

  String time(date) {
    var dateValue = DateFormat("yyyy-MM-ddTHH:mm:ss").parseUTC(date);
    String formattedDate = DateFormat("hh:mm").format(dateValue);
    return formattedDate;
  }

  videoCallDisplay(index) {
    setState(() {
      GlobalVariables.selectedRoomName =
          items[index]['employee']['first_name'].toString() +
              ' ' +
              items[index]['employee']['last_name'].toString();
    });
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      builder: (context) {
        return SizedBox(
          height: GlobalVariables.gHeight,
          child: const MeetingViewNew(),
        );
      },
    );
  }

  errorModal() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CoreColor().backgroundContainer,
          scrollable: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "It's not time",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: GlobalVariables.gWidth,
                child: MaterialButton(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  color: CoreColor().appGreen,
                  child: Text(
                    'OK',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  onPressed: () {
                    setState(() {
                      Get.back();
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
