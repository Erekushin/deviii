import 'dart:convert';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/gextensions.dart';
import 'package:devita/helpers/global_words.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/services/services.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class Checklist extends StatefulWidget {
  const Checklist({Key? key}) : super(key: key);

  @override
  _ChecklistState createState() => _ChecklistState();
}

class _ChecklistState extends State<Checklist> {
  List checkItems = [];
  List userChecked = [];

  RxBool result = false.obs;
  RxBool diagnoses = false.obs;
  RxBool record = false.obs;
  RxBool disease = false.obs;
  RxBool diseases = false.obs;
  RxBool dises = false.obs;
  RxInt totalStep = 0.obs;

  @override
  void initState() {
    super.initState();
    checkList();
  }

  checkList() {
    var bodyData = {};

    Services()
        .postRequest(json.encode(bodyData),
            '${CoreUrl.baseUrl}metadata/unoffical/get/diseases', true)
        .then(
      (data) {
        var response = json.decode(data.body);
        setState(
          () {
            checkItems = response['result']['items'];
            print(checkItems);
            for (var i = 0; i < checkItems.length; i++) {
              if (checkItems[i]["is_selected"] == 1) {
                userChecked.add(checkItems[i]["id"]);
              }
            }
          },
        );
      },
    );
  }

  saveRecord() {
    var bodyData = {
      "ids": userChecked,
    };
    print("saveRecord: $bodyData");

    Services()
        .postRequest(json.encode(bodyData),
            '${CoreUrl.baseUrl}metadata/unoffical/set/diseases', true)
        .then(
      (data) {
        var response = json.decode(data.body);
        setState(() {
          if (response['code'] == 200) {
            modal();
          } else {
            Get.snackbar(
              gWarning,
              'Error',
              colorText: Colors.black,
            );
          }
        });
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
            'r101315'.coreTranslationWord(),
          ),
          elevation: 0,
          centerTitle: true,
          actions: const [],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            child: Container(
              width: GlobalVariables.gWidth / 1.1,
              padding: const EdgeInsets.only(
                top: 15,
              ),
              child: searchInput(),
            ),
          ),
          Container(
            height: (GlobalVariables.gHeight - 300),
            margin: const EdgeInsets.only(top: 15, left: 15),
            child: listCheckbox(),
          ),
          const SizedBox(height: 40),
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
                  saveRecord();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  listCheckbox() {
    return ListView.builder(
        itemCount: checkItems.length,
        itemBuilder: (context, i) {
          return ListTile(
            title: Text(checkItems[i]['name']),
            trailing: Checkbox(
              value: checkItems[i]["is_selected"] == 1
                  ? true
                  : false, //userChecked.contains(checkItems[i]['id']),
              onChanged: (val) {
                _onSelected(val!, i);
              },
            ),
            //you can use checkboxlistTile too
          );
        });
  }

  void _onSelected(bool isSelected, int index) {
    if (isSelected) {
      userChecked.add(checkItems[index]["id"]);
    } else {
      if (userChecked.contains(checkItems[index]["id"])) {
        print("yes olson");
        var ind = userChecked.indexOf(checkItems[index]['id']);
        print(ind);
        userChecked.removeAt(ind);
      }
    }

    print(userChecked);
    setState(() {
      checkItems[index]["is_selected"] = isSelected ? 1 : 0;
    });
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
