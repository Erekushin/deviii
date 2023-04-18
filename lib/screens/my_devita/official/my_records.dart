import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class MyrecordPage extends StatefulWidget {
  const MyrecordPage({Key? key}) : super(key: key);

  @override
  State<MyrecordPage> createState() => _MyrecordPageState();
}

class _MyrecordPageState extends State<MyrecordPage> {
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
            title: const Text('My records'),
            elevation: 0,
            centerTitle: true,
            actions: const [],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              myrecord(),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
            ],
          ),
        ));
  }

  Widget myrecord() {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
            top: 30,
            left: 30,
            right: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Text(
                'Data successfully saved.',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Your records are currently being reviewed and   saved in the DEVITA system.While your data is   being processed, you can't make any updates to   your record. You will be notified after the data     review process is completed. ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontStyle: FontStyle.normal),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Container(
          padding: const EdgeInsets.only(
            left: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 260,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0),
                        side: BorderSide(
                          color: CoreColor().appGreen,
                          width: 2.0,
                        ),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      CoreColor().appGreen,
                    ),
                    textStyle: MaterialStateProperty.all(
                      const TextStyle(fontSize: 15),
                    ),
                  ),
                  child: const Text(
                    'View entry',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    setState(() {
                      Get.to(() => const MyrecordPage());
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 260,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0),
                        side: BorderSide(
                          color: CoreColor().appGreen,
                          width: 2.0,
                        ),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      CoreColor().appGreen,
                    ),
                    textStyle: MaterialStateProperty.all(
                      const TextStyle(fontSize: 15),
                    ),
                  ),
                  child: const Text(
                    'Back to my records',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
