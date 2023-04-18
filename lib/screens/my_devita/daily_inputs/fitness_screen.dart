import 'dart:convert';

import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/services/services.dart';
import 'package:devita/style/color.dart';
import 'package:devita/widget/calendar_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:devita/helpers/gextensions.dart';

class ChartData {
  ChartData(this.x, this.y1);
  final String x;
  final int y1;
}

class FitnessScreen extends StatefulWidget {
  const FitnessScreen({Key? key}) : super(key: key);

  @override
  _FitnessScreenState createState() => _FitnessScreenState();
}

class _FitnessScreenState extends State<FitnessScreen> {
  final String someText =
      "The amount of sleep needed is different for each person. Keep\n"
      "track of your sleeping habits to find your optimal sleep time";
  List dailyListData = [
    {
      "day": "10/24 Sunday",
      "title": "Weightlifting",
      "value": "Gangnam Fitness Club",
      "indicatorValue": "19:30 - 20:30",
    },
    {
      "day": "10/24 Sunday",
      "title": "Morning yoga",
      "value": "Home",
      "indicatorValue": "07:10 - 08:00"
    },
    {
      "day": "10/24 Sunday",
      "title": "Cardio routine",
      "value": "Gangnam Fitness Club",
      "indicatorValue": "19:45 - 20:45"
    },
    {
      "day": "10/24 Sunday",
      "title": "Morning run",
      "value": "Banpo Hangang Park",
      "indicatorValue": "06:45 - 07:45"
    },
  ];
  List eventList = [];
  var datestart = DateTime.now();
  var dateend = DateTime.now();
  dataStep() {
    var bodyData = {
      "number": 2,
      "user_id": GlobalVariables.id,
      "datestart": DateTime.now(),
      "dateend": DateTime.now(),
    };
    print('da');
    print(bodyData);
    Services()
        .postRequest(json.encode(bodyData), '${CoreUrl.baseUrl}data/step', true)
        .then((data) {
      var response = json.decode(data.body);
      setState(() {
        eventList = response['result']['items'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  ///View Widget Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          title: const Text(
            'Fitness History',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          elevation: 0,
          centerTitle: true,
          actions: const [],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: GlobalVariables.gHeight / 5,
              child: const CalendarListWidget(),
            ),
            const SizedBox(height: 10),
            const Divider(
              color: Colors.white54,
            ),
            const SizedBox(height: 10),
            const Text(
              'TODAY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                setState(() {
                  setTarget();
                });
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  '+ Add new entry',
                  style: TextStyle(
                    color: CoreColor().appGreen,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: GlobalVariables.gHeight - 350,
              child: entryList(),
            )
          ],
        ),
      ),
    );
  }

  Widget entryList() {
    return ListView.builder(
      itemCount: dailyListData.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            setState(() {});
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(42, 46, 50, 1),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: ListTile(
              leading: null,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dailyListData[index]['day'],
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${dailyListData[index]['title']}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const SizedBox(
                    height: 3,
                    child: Divider(
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
              subtitle: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dailyListData[index]['value'],
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        dailyListData[index]['indicatorValue'],
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }

  setTarget() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
        ),
        builder: (index) {
          return SizedBox(
            height: GlobalVariables.gHeight - 220,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 10),
                  child: const Text(
                    'New Fitness Entry',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                const Divider(
                  color: Colors.white38,
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Title',
                    style: const TextStyle().bodyText1(),
                  ),
                ),
                const SizedBox(height: 10),
                textForm(),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Exercise routine',
                    style: const TextStyle().bodyText1(),
                  ),
                ),
                const SizedBox(height: 10),
                textForm(),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Time',
                    style: const TextStyle().bodyText1(),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: GlobalVariables.gWidth - 20,
                  child: Row(
                    children: [
                      Expanded(
                        child: textForm(),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        '~',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: textForm(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Location (Country)',
                    style: const TextStyle().bodyText1(),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: GlobalVariables.gWidth - 20,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      fillColor: CoreColor().grey,
                      hintText: "",
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0)),
                        borderSide:
                            BorderSide(color: CoreColor().grey, width: 1.0),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0)),
                        borderSide:
                            BorderSide(color: CoreColor().grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0)),
                        borderSide:
                            BorderSide(color: CoreColor().grey, width: 1.0),
                      ),
                    ),
                    isExpanded: true,
                    hint: const Text(''),
                    items: <String>['Ulaanbaatar', 'Darkhan', 'Erdenet']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (_) {},
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'How do you feel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.account_circle,
                      size: 40,
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.account_circle,
                      size: 40,
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.account_circle,
                      size: 40,
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.account_circle,
                      size: 40,
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.account_circle,
                      size: 40,
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.account_circle,
                      size: 40,
                    )
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: GlobalVariables.gWidth / 2,
                  child: MaterialButton(
                    color: CoreColor().appGreen,
                    child: Text(
                      'Save',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    onPressed: () {
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget textForm() {
    return SizedBox(
      width: GlobalVariables.gWidth - 20,
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          fillColor: CoreColor().grey,
          hintText: "",
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: CoreColor().grey, width: 1.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: CoreColor().grey, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: CoreColor().grey, width: 1.0),
          ),
        ),
      ),
    );
  }
}
