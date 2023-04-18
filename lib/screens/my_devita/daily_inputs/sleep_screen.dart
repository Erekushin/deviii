import 'package:devita/helpers/gvariables.dart';
import 'package:devita/style/color.dart';
import 'package:devita/widget/calendar_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ChartData {
  ChartData(this.x, this.y1);
  final String x;
  final int y1;
}

class SleepScreen extends StatefulWidget {
  const SleepScreen({Key? key}) : super(key: key);

  @override
  _SleepScreenState createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  final List<ChartData> chartData = [
    ChartData('Sun', 15000),
    ChartData('Mon', 5400),
    ChartData('Tue', 4600),
    ChartData('Wed', 5800),
    ChartData('Thu', 3500),
    ChartData('Fri', 6000),
    ChartData('Sat', 7800),
  ];

  final String someText =
      "The amount of sleep needed is different for each person. Keep\n"
      "track of your sleeping habits to find your optimal sleep time";

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
            'Sleep',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          elevation: 0,
          centerTitle: true,
          actions: [
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
                  'Set Target',
                  style: TextStyle(
                    color: CoreColor().appGreen,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
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
            const Text(
              'TODAY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              width: 200,
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    alignment: Alignment.topCenter,
                    child: const Text(
                      '12',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    alignment: Alignment.bottomCenter,
                    child: const Text(
                      '6',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      '9',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    child: const Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        value: 0.65,
                        strokeWidth: 7,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          CoreColor().appGreen,
                        ),
                        backgroundColor: Colors.grey[700],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Center(
                        child: Text(
                          "8",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 45,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "HOURS",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '4 HOURSd TO GO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              child: filters(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <ChartSeries>[
                    StackedColumnSeries<ChartData, String>(
                      color: CoreColor().appGreen,
                      dataSource: chartData,
                      xValueMapper: (ChartData sales, _) => sales.x,
                      yValueMapper: (ChartData sales, _) => sales.y1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filters() {
    return Container(
      width: GlobalVariables.gWidth - 50,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5, left: 5),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'D',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5, left: 5),
              decoration: BoxDecoration(
                color: CoreColor().appGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'W',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5, left: 5),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'M',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5, left: 5),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Y',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
        builder: (context) {
          return SizedBox(
            height: GlobalVariables.gHeight - 220,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 10),
                  child: const Text(
                    'Set target',
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
                Text(
                  someText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    height: 1.5,
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: GlobalVariables.gWidth - 50,
                  child: Row(
                    children: [
                      const Text(
                        'BedTime',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: GlobalVariables.gWidth / 2,
                        child: const Divider(
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '11:00 PM',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: GlobalVariables.gWidth - 50,
                  child: SfLinearGauge(
                    maximum: 24.0,
                    minimum: 1.0,
                    ranges: null,
                    markerPointers: null,
                    barPointers: const [
                      LinearBarPointer(value: 11),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: GlobalVariables.gWidth - 50,
                  child: Row(
                    children: [
                      const Text(
                        'Wake-up time',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: GlobalVariables.gWidth / 2,
                        child: const Divider(
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '07:00 AM',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: GlobalVariables.gWidth - 50,
                  child: SfLinearGauge(
                    maximum: 24.0,
                    minimum: 1.0,
                    ranges: null,
                    markerPointers: null,
                    barPointers: const [
                      LinearBarPointer(value: 7),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  margin: const EdgeInsets.only(left: 30),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Sleep duration: 8 hrs',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
