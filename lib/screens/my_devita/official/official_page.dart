import 'dart:convert';

import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/gextensions.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/screens/my_devita/official/data_input_page.dart';
import 'package:devita/screens/my_devita/official/overview_page.dart';
import 'package:devita/screens/my_devita/official/record_detail.dart';
import 'package:devita/services/services.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OfficialPage extends StatefulWidget {
  const OfficialPage({Key? key}) : super(key: key);

  @override
  _OfficialPageState createState() => _OfficialPageState();
}

class _OfficialPageState extends State<OfficialPage> {
  List dailyListData = [];

  RxBool result = false.obs;
  RxBool diagnoses = false.obs;
  RxBool record = false.obs;
  DateFormat timeFormat = DateFormat("yyyy-MM-dd");

  @override
  void initState() {
    super.initState();
    getUserDataList();
  }

  getUserDataList() {
    print('data list diid');
    var bodyData = {};
    Services()
        .postRequest(json.encode(bodyData),
            "${CoreUrl.baseUrl}metadata/offical/list", true)
        .then((data) {
      var res = json.decode(data.body);
      setState(() {
        dailyListData = res['result']['items'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CoreColor().backgroundNew,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: CoreColor().backgroundContainer,
          automaticallyImplyLeading: true,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_sharp,
              size: 30,
              color: CoreColor().appGreen,
            ),
          ),
          leadingWidth: 80,
          titleSpacing: 0.0,
          title: Text(
            'r101320'.coreTranslationWord(),
          ),
          elevation: 0,
          centerTitle: true,
          actions: const [],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: <Widget>[
            searchInput(),
            const SizedBox(height: 10),
            const Divider(
              color: Colors.grey,
              height: 2,
            ),
            SizedBox(
              height: 45,
              child: Container(
                child: addRecord(),
              ),
            ),
            dailyListData.isEmpty
                ? Container()
                : SizedBox(
                    height: GlobalVariables.gHeight - 250,
                    child: dailyList(),
                  )
          ],
        ),
      ),
    );
  }

  Widget addRecord() {
    return Center(
      child: TextButton.icon(
        icon: Icon(
          Icons.add,
          color: CoreColor().appGreen,
        ),
        label: Text(
          'r101321'.coreTranslationWord(),
          style: TextStyle(
            color: CoreColor().appGreen,
          ),
        ),
        onPressed: () {
          setState(() {
            // Get.to(() => const Datainput());
            Get.to(() => const OverviewPage());
          });
        },
      ),
    );
  }

  Widget searchInput() {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
            top: 10,
            left: 15,
          ),
          child: Text(
            'r101322'.coreTranslationWord(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 17,
            ),
          ),
        ),
        Positioned(
          child: Container(
            padding: const EdgeInsets.only(
              top: 35,
              left: 10,
              right: 10,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 1.0),
                      ),
                      disabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 1.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 1.0),
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: CoreColor().appGreen,
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {});
                          }),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      hintText: "Search",
                      hintStyle: const TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                      fillColor: CoreColor().backgroundContainer,
                    ),
                  ),
                ),
                Container(
                  width: 10,
                ),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: ElevatedButton(
                    child: const Icon(
                      Icons.filter_alt_sharp,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        // filter();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(
                        top: 2,
                        bottom: 2,
                      ),
                      primary: CoreColor().backgroundContainer,
                      onPrimary: CoreColor().appGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget dailyList() {
    return ListView.builder(
      itemCount: dailyListData.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Get.to(() =>
                RecordDetailPage(detailValue: dailyListData[index]['id']));
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: CoreColor().backgroundContainer,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            child: ListTile(
              leading: null,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Time: ${dailyListData[index]['start_time']}",
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${dailyListData[index]['title']}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Divider(color: Colors.grey, height: 2),
                ],
              ),
              subtitle: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${dailyListData[index]['instution']}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      timeFormat.format(DateTime.now()),
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  filter() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CoreColor().backgroundFilter,
          scrollable: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 120),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Filter',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 70),
                    IconButton(
                      icon: const Icon(
                        Icons.cancel,
                        size: 35,
                      ),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          Get.back();
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Text(
                      'Type',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'Test Results',
                          style: TextStyle(fontSize: 15.0),
                        ),
                        Obx(
                          () => Checkbox(
                            value: result.value,
                            onChanged: (value) {
                              setState(() {
                                result.value = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'Diagnoses',
                          style: TextStyle(fontSize: 15.0),
                        ),
                        Obx(
                          () => Checkbox(
                            value: diagnoses.value,
                            onChanged: (value) {
                              setState(() {
                                diagnoses.value = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'Records',
                          style: TextStyle(fontSize: 15.0),
                        ),
                        Obx(
                          () => Checkbox(
                            value: record.value,
                            onChanged: (value) {
                              setState(() {
                                record.value = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.grey,
                      height: 2,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: const [
                    Text(
                      "Time",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: Column(
            children: [
              const Text(
                'Start Date',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                width: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white,
                    width: 1.0,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      print("darlaa");
                    });
                  },
                  child: Text(
                    DateFormat("yyyy-MM-dd").format(
                      DateTime.now(),
                    ),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'End Date',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 55,
                width: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white,
                    width: 1.0,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
                child: TextButton(
                  onPressed: () {},
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        print("darlaa");
                      });
                    },
                    child: Text(
                      DateFormat("yyyy-MM-dd").format(
                        DateTime.now(),
                      ),
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 17),
              const Divider(
                color: Colors.grey,
                height: 2,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: const [
                    Text(
                      "Location",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 40,
                width: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white,
                    width: 1.0,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
                child: const Text(
                  "London, UK",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
