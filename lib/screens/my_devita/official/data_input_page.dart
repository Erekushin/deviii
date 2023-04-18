import 'package:devita/helpers/gextensions.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'overview_page.dart';

class Datainput extends StatefulWidget {
  const Datainput({Key? key}) : super(key: key);

  @override
  _DatainputState createState() => _DatainputState();
}

class _DatainputState extends State<Datainput> {
  List dailyListData = [
    {
      "title": 'r101323'.coreTranslationWord(),
    },
    {
      "title": 'r101324'.coreTranslationWord(),
    },
    {
      "title": 'r101325'.coreTranslationWord(),
    },
    {
      "title": 'r101326'.coreTranslationWord(),
    },
    {
      "title": 'r101327'.coreTranslationWord(),
    }
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
            'r101314'.coreTranslationWord(),
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
            setState(() {
              Get.to(() => const OverviewPage());
            });
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
                      fontSize: 17,
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

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: CoreColor().backgroundContainer,
        content: const Text(
          'Coming Soon',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.white,
          onPressed: scaffold.hideCurrentSnackBar,
        ),
      ),
    );
  }
}
