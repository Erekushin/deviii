import 'dart:convert';

import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/gextensions.dart';
import 'package:devita/helpers/global_words.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/screens/my_devita/unofficial/unofficial_page.dart';
import 'package:devita/services/services.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JournalList extends StatefulWidget {
  const JournalList({Key? key}) : super(key: key);

  @override
  _JournalListState createState() => _JournalListState();
}

class _JournalListState extends State<JournalList> {
  RxBool result = false.obs;
  RxBool diagnoses = false.obs;
  RxBool diagnosese = false.obs;
  RxBool record = false.obs;
  RxBool records = false.obs;
  RxBool disease = false.obs;
  RxBool diseases = false.obs;
  List journalItems = [];
  List checkedJournal = [];
  var textEditingControllers = <TextEditingController>[];
  var textFields = <Widget>[];

  @override
  void initState() {
    super.initState();

    journalListServer();
  }

  journalListServer() {
    var bodyData = {};

    Services()
        .postRequest(json.encode(bodyData),
            '${CoreUrl.baseUrl}metadata/unoffical/get/self/diseases', true)
        .then(
      (data) {
        var response = json.decode(data.body);
        setState(() {
          journalItems = response['result']['items'];

          for (var i = 0; i < journalItems.length; i++) {
            var textEditingController =
                TextEditingController(text: journalItems[i]["description"]);
            textEditingControllers.add(textEditingController);
            textFields.add(Column(
              children: [
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${journalItems[i]['disease']['name']}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(color: Colors.grey, height: 4),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: TextFormField(
                    controller: textEditingController,
                    onChanged: (value) {
                      _onchengeTextField(value, i);
                    },
                  ),
                ),
              ],
            ));
          }
        });
      },
    );
  }

  setSave() {
    var bodyData = {
      "items": checkedJournal,
    };
    print("body: $checkedJournal");
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
      resizeToAvoidBottomInset: true,
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
            'r101317'.coreTranslationWord(),
          ),
          elevation: 0,
          centerTitle: true,
          actions: const [],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              child: Container(
                width: GlobalVariables.gWidth / 1.1,
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 15,
                ),
                child: searchInput(),
              ),
            ),
            SizedBox(
              child: Container(
                width: GlobalVariables.gWidth / 1.2,
                margin: const EdgeInsets.only(top: 25, left: 20),
                child: listJournal(),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              child: saveClick(),
            ),
          ],
        ),
      ),
    );
  }

  Widget listJournal() {
    return SingleChildScrollView(
      child: Column(
        children: textFields,
      ),
    );
  }

  void _onchengeTextField(desc, index) {
    var item = {
      "id": journalItems[index]["id"],
      "status": journalItems[index]["status"],
      "description": desc ?? ""
    };
    if (checkedJournal.isNotEmpty) {
      if (_arrayChecker(journalItems[index]["id"])[0]) {
        checkedJournal[_arrayChecker(journalItems[index]["id"])[1]] = item;
      } else {
        checkedJournal.add(item);
      }
    } else {
      checkedJournal.add(item);
    }
  }

  _arrayChecker(id) {
    for (var i = 0; i < checkedJournal.length; i++) {
      if (checkedJournal[i]["id"] == id) {
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

  Widget saveClick() {
    return Container(
      padding: const EdgeInsets.only(top: 25),
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
