import 'package:devita/helpers/gextensions.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/screens/my_devita/unofficial/check_list.dart';
import 'package:devita/screens/my_devita/unofficial/journal_list.dart';
import 'package:devita/screens/my_devita/unofficial/single_entry.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Devitaofficial extends StatefulWidget {
  const Devitaofficial({Key? key}) : super(key: key);

  @override
  _DevitaofficialState createState() => _DevitaofficialState();
}

class _DevitaofficialState extends State<Devitaofficial> {
  List dailyListData = [
    {
      "title": 'r101315'.coreTranslationWord(),
    },
    {
      "title": 'r101316'.coreTranslationWord(),
    },
    {
      "title": 'r101317'.coreTranslationWord(),
    },
  ];

  @override
  void initState() {
    super.initState();
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
            'r101334'.coreTranslationWord(),
          ),
          elevation: 0,
          centerTitle: true,
          actions: const [],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
        ),
        child: dailyList(),
      ),
    );
  }

  Widget dailyList() {
    return ListView.builder(
      itemCount: dailyListData.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            switch (index) {
              case 0:
                Get.to(() => const Checklist());
                break;
              case 1:
                Get.to(() => const Singleentry());
                break;

              case 2:
                print('sda');

                Get.to(
                  () => const JournalList(),
                );
                break;

              default:
            }
          },
          child: Container(
            height: GlobalVariables.gHeight / 12,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: CoreColor().backgroundContainer,
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: ListTile(
              leading: null,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${dailyListData[index]['title']}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_right,
                    size: 30,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
