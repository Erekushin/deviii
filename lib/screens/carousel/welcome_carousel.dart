import 'package:devita/helpers/gextensions.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class WelcomeCarousel extends StatelessWidget {
  const WelcomeCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: const PageViewDemo(),
        ),
      ),
    );
  }
}

class PageViewDemo extends StatefulWidget {
  const PageViewDemo({Key? key}) : super(key: key);

  @override
  _PageViewDemoState createState() => _PageViewDemoState();
}

class _PageViewDemoState extends State<PageViewDemo> {
  final PageController _controller = PageController(initialPage: 0);

  int selectedindex = 0;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: 3,
      onPageChanged: (int page) {
        setState(() {
          selectedindex = page;
        });
      },
      itemBuilder: (context, index) {
        return test(context, index);
      },
    );
  }

  Widget test(context, index) {
    return Container(
      margin: const EdgeInsets.only(left: 70),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 200),
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                bottomLeft: Radius.circular(25),
              ),
            ),
            width: GlobalVariables.gWidth,
            height: 350,
          ),
          const SizedBox(height: 20),
          Text(
            'r101177'.coreTranslationWord(),
            style: TextStyle(
              color: CoreColor().appGreen,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 20),
          const SizedBox(
            width: 250,
            child: Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. ',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {},
                child: Text(
                  'r101362'.coreTranslationWord(),
                  style: TextStyle(
                    color: CoreColor().appGreen,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 20),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'r101350'.coreTranslationWord(),
                        style: TextStyle(
                          color: CoreColor().appGreen,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.circle,
                      color: CoreColor().appGreen,
                      size: 50,
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
