import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/services/services.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:devita/helpers/gextensions.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationPage> {
  List items = [];
  var button = <Widget>[];
  int pageNumber = 10;

  @override
  void initState() {
    getNotificationList();
    super.initState();
  }

  getNotificationList() {
    var bodyData = {
      "limit": pageNumber,
    };
    Services()
        .postRequest(json.encode(bodyData),
            '${CoreUrl.baseUrl}calendar/notification/list', true)
        .then(
      (data) {
        var response = json.decode(data.body);
        setState(() {
          items = response['result']['items'];
          var buttonBody = {
            "created_date": "",
            "data": {
              "emp_id": "button",
            }
          };
          items.add(buttonBody);
        });
      },
    );
  }

  String time(date) {
    var dateValue = DateFormat("yyyy-MM-ddTHH:mm:ss").parseUTC(date);
    String formattedDate = DateFormat("yyyy-MM-dd h:mm a").format(dateValue);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: CoreColor().backgroundNew,
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 1,
          centerTitle: true,
          backgroundColor: CoreColor().appbarColor,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            tabs: [
              Tab(text: "r101211".coreTranslationWord()),
              Tab(text: "r101212".coreTranslationWord()),
              Tab(text: "r101213".coreTranslationWord()),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            appointment(),
            wallet(),
            announcement(),
          ],
        ),
      ),
    );
  }

  Widget appointment() {
    return ListView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      padding: const EdgeInsets.all(5),
      scrollDirection: Axis.vertical,
      itemBuilder: (con, index) {
        return Container(
          height: items[index]['data']['emp_id'] == "button" ? 60 : 80,
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: items[index]['data']['emp_id'] == "button"
                ? Colors.transparent
                : const Color.fromRGBO(42, 46, 50, 1),
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: items[index]['data']['emp_id'] == "button"
              ? MaterialButton(
                  onPressed: () {
                    print('darsan next');
                    setState(() {
                      pageNumber = pageNumber + 10;
                      print(pageNumber);
                      getNotificationList();
                    });
                  },
                  child: Text(
                    'Үргэлжлүүлэх',
                    style: TextStyle(
                      color: CoreColor().appGreen,
                      fontSize: 14,
                    ),
                  ),
                )
              : ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(60.0),
                    child: items[index]['data']['emp_profileImageUrl'] == null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Image.asset(
                              "assets/images/userprofile.png",
                              width: 60,
                              height: 60,
                              fit: BoxFit.fitWidth,
                            ),
                          )
                        : CachedNetworkImage(
                            width: 60,
                            height: 60,
                            imageUrl: CoreUrl.imageUrl +
                                items[index]['data']['emp_profileImageUrl'],
                            fit: BoxFit.fitWidth,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                          ),
                  ),
                  title: RichText(
                    text: TextSpan(
                      text: "${items[index]['data']['emp_username']} ",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      children: <InlineSpan>[
                        TextSpan(
                          text: 'm101032'.coreTranslationWord(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        TextSpan(
                          text: " ${items[index]['type']} ",
                        ),
                        TextSpan(
                          text: 'm101007'.coreTranslationWord(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        TextSpan(
                          text: "\n${time(items[index]['created_date'])}",
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget wallet() {
    return ListView.builder(
      itemBuilder: (con, index) {
        return Container(
          margin: const EdgeInsets.only(top: 150),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Path_216.png',
              ),
              const SizedBox(height: 30),
              Text(
                'r101057'.coreTranslationWord(),
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 35,
                ),
              ),
            ],
          ),
        );
        //  Container(
        //   margin: const EdgeInsets.all(8),
        //   padding: const EdgeInsets.only(top: 10, bottom: 10),
        //   decoration: const BoxDecoration(
        //     color: Color.fromRGBO(42, 46, 50, 1),
        //     borderRadius: BorderRadius.all(
        //       Radius.circular(10.0),
        //     ),
        //   ),
        //   child: ListTile(
        //     leading: ClipRRect(
        //       borderRadius: BorderRadius.circular(60.0),
        //       child: Image.asset('assets/images/userprofile.png',
        //           width: 60, height: 60, fit: BoxFit.fitWidth),
        //     ),
        //     title: RichText(
        //       text: const TextSpan(
        //         text: 'William Sims',
        //         style: TextStyle(fontWeight: FontWeight.bold),
        //         children: <TextSpan>[
        //           TextSpan(
        //             text: '  sent you 2 Life',
        //             style: TextStyle(
        //               fontWeight: FontWeight.normal,
        //               color: Colors.white70,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     subtitle: Container(
        //       padding: const EdgeInsets.only(top: 10),
        //       child: const Text(
        //         "Yesterday, 12:08",
        //         style: TextStyle(
        //           color: Colors.grey,
        //         ),
        //       ),
        //     ),
        //   ),
        // );
      },
      itemCount: 1,
      shrinkWrap: true,
      padding: const EdgeInsets.all(5),
      scrollDirection: Axis.vertical,
    );
  }

  Widget announcement() {
    return ListView.builder(
      itemBuilder: (con, index) {
        return Container(
          margin: const EdgeInsets.only(top: 150),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Path_216.png',
              ),
              const SizedBox(height: 30),
              Text(
                'r101057'.coreTranslationWord(),
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 35,
                ),
              ),
            ],
          ),
        );

        // InkWell(
        //   onTap: () {
        //     setState(() {
        //       modal();
        //     });
        //   },
        //   child: Container(
        //     margin: const EdgeInsets.all(8),
        //     padding: const EdgeInsets.only(top: 10, bottom: 10),
        //     decoration: const BoxDecoration(
        //       color: Color.fromRGBO(42, 46, 50, 1),
        //       borderRadius: BorderRadius.all(
        //         Radius.circular(10.0),
        //       ),
        //     ),
        //     child: ListTile(
        //       leading: ClipRRect(
        //         borderRadius: BorderRadius.circular(10.0),
        //         child: Image.asset('assets/images/userprofile.png',
        //             width: 60, height: 60, fit: BoxFit.fitWidth),
        //       ),
        //       title: const Text(
        //         'Announcement Title',
        //         style: TextStyle(
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //       subtitle: Column(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Container(
        //             alignment: Alignment.centerLeft,
        //             child: const Text(
        //               "1 Octomber, 15:00 ",
        //               style: TextStyle(
        //                 color: Colors.grey,
        //               ),
        //             ),
        //           ),
        //           const SizedBox(height: 10),
        //           const Text(
        //             'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam posuere quam in luctus suscipit. Aenean porttitor justo vel bibendum condimentum. Praesent eu commodo sapien, vitae lobortis dui. Nulla facilisi. In rutrum libero et aliquet mattis. Morbi mattis nibh quis tellus pellentesque imperdiet.',
        //             style: TextStyle(
        //               color: Colors.white,
        //               fontWeight: FontWeight.w300,
        //             ),
        //           ),
        //           const SizedBox(height: 10),
        //           InkWell(
        //             onTap: () {},
        //             child: Text(
        //               'Read more',
        //               textAlign: TextAlign.start,
        //               style: TextStyle(
        //                 fontWeight: FontWeight.w200,
        //                 color: CoreColor().appGreen,
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // );
      },
      itemCount: 1,
      shrinkWrap: true,
      padding: const EdgeInsets.all(5),
      scrollDirection: Axis.vertical,
    );
  }

  // modal() {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         scrollable: true,
  //         shape: const RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(10.0))),
  //         title: Column(
  //           children: [
  //             Text(
  //               'ANNOUNCEMENT',
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 fontSize: 20,
  //                 color: CoreColor().appGreen,
  //               ),
  //             ),
  //             const Text(
  //               '1 Octomber, 15:00',
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 color: Colors.white30,
  //                 fontSize: 12,
  //               ),
  //             ),
  //           ],
  //         ),
  //         content: Column(
  //           children: [
  //             Image.asset('assets/images/telehealth.png'),
  //             const SizedBox(height: 10),
  //             const Text(
  //               'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque fermentum mauris quis purus finibus, non efficitur ante sodales. Ut ullamcorper erat a tincidunt fringilla. Nunc eget laoreet nulla. Cras ultrices gravida sem quis finibus.',
  //               textAlign: TextAlign.justify,
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 12,
  //               ),
  //             ),
  //             const SizedBox(height: 10),
  //             const Text(
  //               'Proin sem neque, sollicitudin a auctor id, luctus a mi. Integer auctor, diam vel interdum blandit, ante mauris blandit nunc, blandit mattis sem libero a quam. Duis nec arcu est. Aliquam a felis iaculis felis pulvinar sodales. Pellentesque bibendum eleifend velit, quis mollis velit sollicitudin in.',
  //               textAlign: TextAlign.justify,
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 12,
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
