import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/gextensions.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/screens/home/appointment_page.dart';
import 'package:devita/screens/user_views/doctor/doctor_info.dart';
import 'package:devita/screens/user_views/doctor/event.dart';
import 'package:devita/services/services.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class DoctorList extends StatefulWidget {
  const DoctorList({Key? key}) : super(key: key);

  @override
  _DoctorListState createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  List items = [];
  List appointmentList = [];
  final selectedDocId = "1";

  @override
  void initState() {
    super.initState();
    listData();
    appointmentData();
  }

  listData() {
    var bodyData = {"search_text": ""};

    Services()
        .postRequest(json.encode(bodyData),
            '${CoreUrl.baseUrl}calendar/user/emp/list', true)
        .then(
      (data) {
        var response = json.decode(data.body);
        setState(
          () {
            items = response['result']['items'];
          },
        );
      },
    );
  }

  appointmentData() {
    String startDate =
        DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    String endDate = DateFormat('yyyy-MM-dd')
        .format(DateTime(kToday.year, kToday.month + 1, 0))
        .toString();
    var appointment = {
      "start_date": startDate,
      "end_date": endDate,
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
      resizeToAvoidBottomInset: false, //searchar used for it test
      backgroundColor: CoreColor().backgroundNew,
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
            'r101082'.coreTranslationWord(),
          ),
          elevation: 0,
          centerTitle: true,
          actions: const [],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          coreMenu(),
          SizedBox(
            height: 70,
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              child: buildFloatingSearchBar(),
            ),
          ),
        ],
      ),
    );
  }

  Widget coreMenu() {
    return Container(
      margin: const EdgeInsets.only(top: 70),
      child: Column(
        children: [
          const Divider(
            color: Colors.white38,
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'r101274'.coreTranslationWord(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    overflow: TextOverflow.fade,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      Get.to(
                        () => const AppointmentPage(),
                      );
                    });
                  },
                  style: TextButton.styleFrom(
                    primary: CoreColor().appGreen,
                  ),
                  child: Text(
                    'r101275'.coreTranslationWord(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            // height: GlobalVariables.gHeight / 2.5,
            // child: rowList(),
            height:
                appointmentList.isEmpty ? 200 : GlobalVariables.gHeight / 3.5,
            child: appointmentList.isEmpty
                ? Center(
                    child: Text(
                      'r101057'.coreTranslationWord(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  )
                : rowList(),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'r101276'.coreTranslationWord(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    overflow: TextOverflow.fade,
                  ),
                ),
                Text(
                  'r101275'.coreTranslationWord(),
                  style: TextStyle(
                    color: CoreColor().appGreen,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (con, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      Get.to(() => DoctorInformtaion(
                          docId: items[index]["id"].toString()));
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                      color: CoreColor().backgroundContainer,
                    ),
                    child: Row(
                      children: [
                        items[index]['profile_img'] == null
                            ? Image.asset("assets/images/userprofile.png")
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(60.0),
                                child: CachedNetworkImage(
                                  imageUrl: CoreUrl.imageUrl +
                                      items[index]['profile_img'],
                                  fit: BoxFit.fitWidth,
                                  width: 60,
                                  height: 60,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                          "assets/images/userprofile.png"),
                                ),
                              ),

                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (items[index]['first_name'].toString() +
                                          '' +
                                          items[index]["last_name"]
                                              .toString()) ==
                                      ""
                                  ? items[index]["cell_no_primary"].toString()
                                  : items[index]['first_name'].toString() +
                                      ' ' +
                                      items[index]["last_name"].toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'r101277'.coreTranslationWord(),
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: CoreColor().grey,
                                  size: 15,
                                ),
                                Text(
                                  'r101278'.coreTranslationWord(),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        // const SizedBox(width: 50),
                        const Flexible(child: SizedBox(), fit: FlexFit.tight),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              alignment: Alignment.centerRight,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                  ),
                                  Text(
                                    '4.5',
                                    style: TextStyle(
                                      color: CoreColor().appGreen,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'r101279'.coreTranslationWord(),
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: items.length,
              shrinkWrap: true,
              padding: const EdgeInsets.all(5),
              scrollDirection: Axis.vertical,
            ),
          ),
        ],
      ),
    );
  }

  Widget rowList() {
    return SizedBox(
      height: GlobalVariables.gHeight / 3.5,
      child: ListView.builder(
        itemBuilder: (con, index) {
          return InkWell(
            onTap: () {
              setState(() {
                Get.to(() => DoctorInformtaion(
                    docId: appointmentList[index]["employee_id"].toString()));
              });
            },
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(6),
              width: GlobalVariables.gWidth / 1.5,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                color: CoreColor().backgroundContainer,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: appointmentList[index]["employee"]['profile_img'] ==
                            null
                        ? Image.asset("assets/images/userprofile.png")
                        : CachedNetworkImage(
                            width: 100,
                            height: 100,
                            imageUrl: CoreUrl.imageUrl +
                                appointmentList[index]["employee"]
                                    ['profile_img'],
                            fit: BoxFit.fitWidth,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Image.asset("assets/images/userprofile.png"),
                          ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        appointmentList[index]['user_description'],
                        style: TextStyle(
                          color: CoreColor().grey,
                        ),
                      ),
                      // const Text(
                      //   'Dr.Medicine',
                      //   style: TextStyle(
                      //     color: Colors.white70,
                      //   ),
                      // ),
                      const SizedBox(height: 5),
                      Text(
                        appointmentList[index]['employee']['first_name']
                                .toString() +
                            ' ' +
                            appointmentList[index]['employee']['last_name']
                                .toString(),
                        style: TextStyle(
                          color: CoreColor().appGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        // '2021.10.25 10:00 AM',
                        appointmentList[index]["date_time"].toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: appointmentList.length,
        shrinkWrap: true,
        padding: const EdgeInsets.all(5),
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  final controller = FloatingSearchBarController();
  List searchResult = [].obs;

  ///Floating searchbar init
  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      automaticallyImplyBackButton: false,
      controller: controller,
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        if (query != "") {
          onQueryChanged(query);
        } else {
          searchResult.clear();
        }
        print(query);
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: SizedBox(
              height: 300,
              child: Obx(
                () => ListView.builder(
                  itemCount: searchResult.length,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      child: Text(
                        '${searchResult[index]["first_name"]}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void onQueryChanged(String query) {
    var bodyData = {
      "search_text": query,
    };
    Services()
        .postRequest(json.encode(bodyData),
            'https://backend.devita.mn/calendar/user/employee/list', true)
        .then(
      (data) {
        var response = json.decode(data.body);
        var res = response["result"]["items"];
        setState(
          () {
            searchResult = res;
          },
        );
      },
    );
  }
}
