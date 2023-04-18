import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/services/services.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:devita/helpers/gextensions.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key? key}) : super(key: key);

  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<AppointmentPage> {
  List items = [];
  List appointmentList = [];

  @override
  void initState() {
    super.initState();
    listData();
    appointmentData();
  }

  listData() {
    var bodyData = {
      "start_date": "2022-01-01",
      "end_date": "2022-01-31",
    };

    Services()
        .postRequest(json.encode(bodyData),
            '${CoreUrl.baseUrl}calendar/user/order/list', true)
        .then((data) {
      var response = json.decode(data.body);
      print(response);
      setState(() {
        items = response['result']['items'];
      });
    });
  }

  appointmentData() {
    var appointment = {
      "start_date": "2022-01-01",
      "end_date": "2022-01-31",
    };
    Services()
        .postRequest(json.encode(appointment),
            '${CoreUrl.baseUrl}calendar/user/order/list', true)
        .then((data) {
      var response = json.decode(data.body);
      print(response);
      setState(
        () {
          appointmentList = response['result']['items'];
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CoreColor().backgroundContainer,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          automaticallyImplyLeading: true,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
          ),
          leadingWidth: 80,
          titleSpacing: 0.0,
          title: Text(
            'r101239'.coreTranslationWord(),
          ),
          elevation: 0,
          centerTitle: true,
          actions: const [],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(
            height: 70,
            child: Container(
              child: listItem(),
            ),
          ),
        ],
      ),
    );
  }

  Widget listItem() {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (con, index) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    print(items[index]);
                    details(index);
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
                      items[index]['profile_img'] == null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Image.asset(
                                'assets/images/userprofile.png',
                                width: 60,
                                height: 60,
                                fit: BoxFit.fitWidth,
                              ),
                            )
                          : CachedNetworkImage(
                              width: 60,
                              height: 60,
                              imageUrl: CoreUrl.imageUrl +
                                  items[index]['profile_img'],
                              fit: BoxFit.fitWidth,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                            ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            items[index]['employee']['first_name'].toString() +
                                ' ' +
                                items[index]['employee']['last_name']
                                    .toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            // '2021.10.25 10:00 AM',
                            appointmentList[index]["date_time"].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            items[index]['user_description'],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 50),
                      SizedBox(
                        height: 30,
                        child: MaterialButton(
                          color: CoreColor().appGreen,
                          child: Text(
                            'r101240'.coreTranslationWord(),
                            // textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              details(index);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Colors.grey,
                height: 5,
              ),
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

  details(index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CoreColor().backgroundContainer,
          scrollable: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(
                  bottom: 2,
                ),
              ),
              Text(
                'r101280'.coreTranslationWord(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: CoreColor().appGreen,
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
            ],
          ),
          content: Column(
            children: [
              Text(
                'r101281'.coreTranslationWord(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              Text(
                appointmentList[index]['employee']['first_name'].toString() +
                    ' ' +
                    appointmentList[index]['employee']['last_name'].toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 17),
              Text(
                'r101282'.coreTranslationWord(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              Text(
                appointmentList[index]['user_description'],
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 17),
              Text(
                'r101242'.coreTranslationWord(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              Text(
                // '2021.10.25 10:00 AM',
                appointmentList[index]["date_time"].toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 17),
              Text(
                'r101283'.coreTranslationWord(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const Text(
                '13:00-14:00',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
