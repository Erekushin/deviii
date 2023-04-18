import 'package:devita/helpers/gvariables.dart';
import 'package:devita/style/color.dart';
import 'package:devita/widget/calendar_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polygon/flutter_polygon.dart';
import 'package:get/get.dart';
import 'package:devita/helpers/gextensions.dart';

class ChartData {
  ChartData(this.x, this.y1);
  final String x;
  final int y1;
}

class FoodScreen extends StatefulWidget {
  const FoodScreen({Key? key}) : super(key: key);

  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final String someText =
      "The amount of sleep needed is different for each person. Keep\n"
      "track of your sleeping habits to find your optimal sleep time";
  List dailyListData = [
    {
      "title": "Breakfast",
      "value": "Americano, Toasted White Bread, Tortilla...",
    },
    {
      "title": "Lunch",
      "value": "Americano, Toasted White Bread, Tortilla...",
    },
    {
      "title": "Dinner",
      "value": "",
    },
    {
      "title": "Morning snack",
      "value": "",
    },
    {
      "title": "Afternoon snack",
      "value": "",
    },
    {
      "title": "Evening snack",
      "value": "",
    },
  ];
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
            'Food',
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
            SizedBox(
              width: 150,
              child: ClipPolygon(
                sides: 6,
                borderRadius: 1.0,
                rotate: 60.0,
                boxShadows: [
                  PolygonBoxShadow(color: Colors.white, elevation: 1.5),
                  PolygonBoxShadow(color: Colors.white, elevation: 1.5),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: GlobalVariables.gHeight / 4,
              child: entryList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Nutrient intake Summarry',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Row(
              //  crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10,
                  height: 10,
                  child: CircleAvatar(
                    backgroundColor: CoreColor().appGreen,
                  ),
                ),
                const Text(
                  'Carb (0 g)',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 10,
                  height: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.yellow,
                  ),
                ),
                const Text(
                  'Protein (0 g)',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 10,
                  height: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                  ),
                ),
                const Text(
                  'Fat (0 g)',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
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
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(42, 46, 50, 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: CoreColor().grey,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dailyListData[index]['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            dailyListData[index]['value'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_right,
                      color: CoreColor().appGreen,
                      size: 30,
                    ),
                  )
                ],
              )),
        );
      },
    );
  }

  // setTarget() {
  //   return showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       enableDrag: false,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(40.0),
  //           topRight: Radius.circular(40.0),
  //         ),
  //       ),
  //       builder: (context) {
  //         return SizedBox(
  //           height: GlobalVariables.gHeight - 220,
  //           child: Column(
  //             children: [
  //               Container(
  //                 margin: const EdgeInsets.only(top: 20, bottom: 10),
  //                 child: const Text(
  //                   'New Fitness Entry',
  //                   style: TextStyle(
  //                       color: Colors.white,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 18),
  //                 ),
  //               ),
  //               const Divider(
  //                 color: Colors.white38,
  //               ),
  //               const SizedBox(height: 10),
  //               Container(
  //                 margin: const EdgeInsets.only(left: 10),
  //                 alignment: Alignment.centerLeft,
  //                 child: Text(
  //                   'Title',
  //                   style: const TextStyle().bodyText1(),
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               textForm(),
  //               const SizedBox(height: 10),
  //               Container(
  //                 margin: const EdgeInsets.only(left: 10),
  //                 alignment: Alignment.centerLeft,
  //                 child: Text(
  //                   'Exercise routine',
  //                   style: const TextStyle().bodyText1(),
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               textForm(),
  //               const SizedBox(height: 10),
  //               Container(
  //                 margin: const EdgeInsets.only(left: 10),
  //                 alignment: Alignment.centerLeft,
  //                 child: Text(
  //                   'Time',
  //                   style: const TextStyle().bodyText1(),
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               SizedBox(
  //                 width: GlobalVariables.gWidth - 20,
  //                 child: Row(
  //                   children: [
  //                     Expanded(
  //                       child: textForm(),
  //                     ),
  //                     const SizedBox(width: 5),
  //                     const Text(
  //                       '~',
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     const SizedBox(width: 5),
  //                     Expanded(
  //                       child: textForm(),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               Container(
  //                 margin: const EdgeInsets.only(left: 10),
  //                 alignment: Alignment.centerLeft,
  //                 child: Text(
  //                   'Location (Country)',
  //                   style: const TextStyle().bodyText1(),
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               SizedBox(
  //                 width: GlobalVariables.gWidth - 20,
  //                 child: DropdownButtonFormField(
  //                   decoration: InputDecoration(
  //                     fillColor: CoreColor().grey,
  //                     hintText: "",
  //                     enabledBorder: OutlineInputBorder(
  //                       borderRadius:
  //                           const BorderRadius.all(Radius.circular(12.0)),
  //                       borderSide:
  //                           BorderSide(color: CoreColor().grey, width: 1.0),
  //                     ),
  //                     disabledBorder: OutlineInputBorder(
  //                       borderRadius:
  //                           const BorderRadius.all(Radius.circular(12.0)),
  //                       borderSide:
  //                           BorderSide(color: CoreColor().grey, width: 1.0),
  //                     ),
  //                     focusedBorder: OutlineInputBorder(
  //                       borderRadius:
  //                           const BorderRadius.all(Radius.circular(12.0)),
  //                       borderSide:
  //                           BorderSide(color: CoreColor().grey, width: 1.0),
  //                     ),
  //                   ),
  //                   isExpanded: true,
  //                   hint: const Text(''),
  //                   items: <String>['Ulaanbaatar', 'Darkhan', 'Erdenet']
  //                       .map((String value) {
  //                     return DropdownMenuItem<String>(
  //                       value: value,
  //                       child: Text(value),
  //                     );
  //                   }).toList(),
  //                   onChanged: (_) {},
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               const Text(
  //                 'How do you feel',
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 16,
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: const [
  //                   Icon(
  //                     Icons.account_circle,
  //                     size: 40,
  //                   ),
  //                   SizedBox(width: 10),
  //                   Icon(
  //                     Icons.account_circle,
  //                     size: 40,
  //                   ),
  //                   SizedBox(width: 10),
  //                   Icon(
  //                     Icons.account_circle,
  //                     size: 40,
  //                   ),
  //                   SizedBox(width: 10),
  //                   Icon(
  //                     Icons.account_circle,
  //                     size: 40,
  //                   ),
  //                   SizedBox(width: 10),
  //                   Icon(
  //                     Icons.account_circle,
  //                     size: 40,
  //                   ),
  //                   SizedBox(width: 10),
  //                   Icon(
  //                     Icons.account_circle,
  //                     size: 40,
  //                   )
  //                 ],
  //               ),
  //               const SizedBox(height: 20),
  //               SizedBox(
  //                 width: GlobalVariables.gWidth / 2,
  //                 child: MaterialButton(
  //                   color: CoreColor().appGreen,
  //                   child: Text(
  //                     'Save',
  //                     textAlign: TextAlign.center,
  //                     style: Theme.of(context).textTheme.headline1,
  //                   ),
  //                   onPressed: () {
  //                     setState(() {});
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

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
