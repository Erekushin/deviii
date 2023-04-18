import 'package:devita/screens/home/settings_page.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  int selectedOption = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: options.length + 2,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return const SizedBox(height: 5.0);
          } else if (index == options.length + 1) {
            return const SizedBox(height: 70.0);
          }
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10.0),
            width: double.infinity,
            height: 60.0,
            decoration: BoxDecoration(
              color: CoreColor().backgroundNew,
              borderRadius: BorderRadius.circular(15.0),
              border: selectedOption == index - 1
                  ? Border.all(
                      color: CoreColor().backgroundNew,
                    )
                  : null,
            ),
            child: ListTile(
              title: Text(
                options[index - 1].title,
                style: TextStyle(
                  color: selectedOption == index - 1
                      ? CoreColor().appGreen
                      : Colors.white,
                ),
              ),
              leading: options[index - 1].icon,
              onTap: () {
                setState(() {
                  selectedOption = index - 1;
                  // Get.to(() => const LoginPage());
                });
              },
            ),
          );
        },
      ),
    );
  }
}
