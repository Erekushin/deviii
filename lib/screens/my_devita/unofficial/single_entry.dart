import 'dart:convert';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/gextensions.dart';
import 'package:devita/helpers/global_words.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/services/services.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Singleentry extends StatefulWidget {
  const Singleentry({Key? key}) : super(key: key);

  @override
  _SingleentryState createState() => _SingleentryState();
}

class _SingleentryState extends State<Singleentry> {
  RxBool result = false.obs;
  RxBool diagnoses = false.obs;
  RxBool diagnosese = false.obs;
  RxBool record = false.obs;
  RxBool records = false.obs;
  RxBool disease = false.obs;
  RxBool diseases = false.obs;
  RxList singleItems = [].obs;

  List userChecked = [];

  @override
  void initState() {
    super.initState();
    userCheckList();
  }

  userCheckList() {
    var bodyData = {};

    Services()
        .postRequest(json.encode(bodyData),
            '${CoreUrl.baseUrl}metadata/unoffical/get/self/diseases', true)
        .then(
      (data) {
        var response = json.decode(data.body);
        setState(() {
          singleItems.value = response['result']['items'];
          print(singleItems);
        });
      },
    );
  }

  setSave() {
    var bodyData = {
      "items": userChecked,
    };
    print("body: $userChecked");
    Services()
        .postRequest(json.encode(bodyData),
            "${CoreUrl.baseUrl}metadata/unoffical/update/disease", true)
        .then(
      (data) {
        var response = json.decode(data.body);
        print('orgil $response');
        if (response['code'] == 200) {
          modal();
        } else {
          Get.back();
          Get.snackbar(
            gWarning,
            'Error',
            colorText: Colors.black,
          );
        }
      },
    );
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
            'r101316'.coreTranslationWord(),
          ),
          elevation: 0,
          centerTitle: true,
          actions: const [],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
              child: searchInput(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: GlobalVariables.gHeight - 300,
              child: Container(
                padding: const EdgeInsets.only(top: 15, left: 20, right: 25),
                child: SingleChildScrollView(
                  child: singleList(),
                ),
              ),
            ),
            SizedBox(
              width: GlobalVariables.gWidth - 180,
              child: MaterialButton(
                color: CoreColor().appGreen,
                child: Text(
                  'r101035'.coreTranslationWord(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1,
                ),
                onPressed: () {
                  setState(() {
                    setSave();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget singleList() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(
            right: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'r101318'.coreTranslationWord(),
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(width: 33),
              Text(
                'r101319'.coreTranslationWord(),
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
        Obx(
          () => ListView.builder(
            itemCount: singleItems.length,
            shrinkWrap: true,
            // padding: const EdgeInsets.all(5),
            scrollDirection: Axis.vertical,
            itemBuilder: (con, index) {
              return Column(
                children: [
                  const SizedBox(height: 5),
                  const Divider(color: Colors.grey, height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${singleItems[index]['disease']['name']}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Row(
                        children: [
                          Theme(
                            data: ThemeData(
                              unselectedWidgetColor: CoreColor().appGreen,
                            ),
                            child: Checkbox(
                              activeColor: CoreColor().appGreen,
                              value: singleItems[index]["status"] == 0
                                  ? false
                                  : true,
                              onChanged: (value) {
                                setState(() {
                                  _onSelected(1, value!, index);
                                });
                              },
                            ),
                          ),
                          Theme(
                            data: ThemeData(
                              unselectedWidgetColor: CoreColor().appGreen,
                            ),
                            child: Checkbox(
                              activeColor: CoreColor().appGreen,
                              value: singleItems[index]['status'] == 0
                                  ? true
                                  : false,
                              onChanged: (value) {
                                setState(() {
                                  _onSelected(0, value!, index);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _onSelected(int num, bool selected, index) {
    var item = {
      "id": singleItems[index]["id"],
      "status": num,
      "description": singleItems[index]["description"] ?? "hello",
    };
    if (userChecked.isNotEmpty) {
      if (_arrayChecker(singleItems[index]["id"])[0]) {
        userChecked[_arrayChecker(singleItems[index]["id"])[1]] = item;
      } else {
        userChecked.add(item);
      }
    } else {
      userChecked.add(item);
    }
    singleItems[index]["status"] = num;
  }

  _arrayChecker(id) {
    for (var i = 0; i < userChecked.length; i++) {
      if (userChecked[i]["id"] == id) {
        return [true, i];
      }
    }
    return [false, 0];
  }

  Widget searchInput() {
    return Stack(
      children: <Widget>[
        Positioned(
          child: SizedBox(
            // width: GlobalVariables.gWidth / 3,
            height: GlobalVariables.gHeight / 15,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 1.0),
                      ),
                      disabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 1.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 1.0),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 25,
                        ),
                        onPressed: () {},
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                      hintText: "Search or filter",
                      hintStyle: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                      fillColor: CoreColor().backgroundContainer,
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

  modal() {
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
              Image.asset(
                'assets/images/logo_no_word.png',
                height: 65,
              ),
              const SizedBox(height: 20),
              Text(
                'r101256'.coreTranslationWord(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: CoreColor().appGreen,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: GlobalVariables.gWidth - 80,
                child: MaterialButton(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  color: CoreColor().backgroundNew,
                  child: Text(
                    'r101140'.coreTranslationWord(),
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
