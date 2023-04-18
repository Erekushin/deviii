import 'package:devita/helpers/gextensions.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/screens/user_views/vertication/user_vertication3.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserVerification2 extends StatefulWidget {
  const UserVerification2({Key? key}) : super(key: key);

  @override
  _UserVerification2State createState() => _UserVerification2State();
}

class _UserVerification2State extends State<UserVerification2> {
  bool screen1 = false;
  bool screen2 = false;
  bool screen3 = false;
  bool screen4 = false;

  screenChange(index) {
    switch (index) {
      case 1:
        screen1 = true;
        screen2 = false;
        screen3 = false;
        screen4 = false;
        break;
      case 2:
        screen1 = false;
        screen2 = true;
        screen3 = false;
        screen4 = false;
        break;
      case 3:
        screen1 = false;
        screen2 = false;
        screen3 = true;
        screen4 = false;
        break;
      case 4:
        screen1 = false;
        screen2 = false;
        screen3 = false;
        screen4 = true;
        break;
      default:
    }
  }

  @override
  void initState() {
    screenChange(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: GlobalVariables.gWidth,
        height: GlobalVariables.gHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/background.png",
            ),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: screen1 == true
              ? coreScreen()
              : screen2 == true
                  ? photoGovernment()
                  : screen3 == true
                      ? selfieID()
                      : facialRecog(),
        ),
      ),
    );
  }

  Widget coreScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Container(
            alignment: Alignment.centerLeft,
            child: IconButton(
              iconSize: 30,
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'r101363'.coreTranslationWord(),
            style: context.textTheme.headline2,
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              setState(() {
                screenChange(2);
              });
            },
            child: Container(
              height: 160,
              alignment: Alignment.center,
              width: GlobalVariables.gWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: CoreColor().appGreen,
                  width: 1,
                ),
                color: CoreColor().grey,
              ),
              child: SizedBox(
                width: 300,
                child: Text(
                  'r101364'.coreTranslationWord(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              setState(() {
                screenChange(3);
              });
            },
            child: Container(
              height: 160,
              alignment: Alignment.center,
              width: GlobalVariables.gWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: CoreColor().appGreen,
                  width: 1,
                ),
                color: CoreColor().grey,
              ),
              child: const Text(
                'Selfie with ID',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              setState(() {
                screenChange(4);
              });
            },
            child: Container(
              height: 160,
              alignment: Alignment.center,
              width: GlobalVariables.gWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: CoreColor().appGreen,
                  width: 1,
                ),
                color: CoreColor().grey,
              ),
              child: Text(
                'r101366'.coreTranslationWord(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: GlobalVariables.gWidth,
            child: MaterialButton(
              color: CoreColor().appGreen,
              child: Text(
                'r101367'.coreTranslationWord(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1,
              ),
              onPressed: () {
                setState(() {
                  Get.to(const UserVerification3());
                });
              },
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'r101362'.coreTranslationWord(),
                style: TextStyle(
                  color: CoreColor().appGreen,
                  fontSize: 16,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget photoGovernment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: IconButton(
                iconSize: 30,
                onPressed: () {
                  setState(() {
                    screenChange(1);
                  });
                },
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
            ),
            const SizedBox(width: 55),
            const SizedBox(
              width: 200,
              child: Text(
                'Photo of Government Issued ID Card',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Proof of identity',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 20),
        const Text(
          "We accept national ID cards, driving licenses and passports, The Document must have at least 3 months before its expiry date. The photo must be clear, in color and display the document must be visible in its full size in the photo. File size must be under 10MB and more than 500KB",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        const Divider(
          color: Colors.grey,
          height: 2.0,
        ),
        const SizedBox(height: 20),
        RichText(
          text: TextSpan(
              text: 'Please upload the',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: ' front side ',
                    style: TextStyle(
                      color: CoreColor().appGreen,
                      fontWeight: FontWeight.w400,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // navigate to desired screen
                      }),
                const TextSpan(
                  text: 'of your Continue ID or driver\'s license',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ]),
        ),
        const SizedBox(height: 20),
        MaterialButton(
          color: CoreColor().grey,
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.upload,
                color: CoreColor().appGreen,
                size: 25,
              ),
              Text(
                'Upload',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: CoreColor().appGreen,
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Divider(
          color: Colors.grey,
          height: 2.0,
        ),
        const SizedBox(height: 20),
        RichText(
          text: TextSpan(
              text: 'Please upload the',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: ' back side ',
                    style: TextStyle(
                      color: CoreColor().appGreen,
                      fontWeight: FontWeight.w400,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // navigate to desired screen
                      }),
                const TextSpan(
                  text: 'of your Continue ID or driver\'s license',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ]),
        ),
        const SizedBox(height: 20),
        MaterialButton(
          color: CoreColor().grey,
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.upload,
                color: CoreColor().appGreen,
                size: 25,
              ),
              Text(
                'Upload',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: CoreColor().appGreen,
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: GlobalVariables.gWidth,
          child: MaterialButton(
            color: CoreColor().appGreen,
            child: Text(
              'Continue',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1,
            ),
            onPressed: () {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  Widget selfieID() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: IconButton(
                iconSize: 30,
                onPressed: () {
                  setState(() {
                    screenChange(1);
                  });
                },
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
            ),
            const SizedBox(width: 55),
            const SizedBox(
              width: 200,
              child: Text(
                'Selfie with ID',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Proof of identity',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 20),
        const Text(
          "Please upload a clear photo of yourself holding your proof of identity. Please make sure that your document are fully visible in the photo. Max file size 10MB",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        const Divider(
          color: Colors.grey,
          height: 2.0,
        ),
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.center,
          width: GlobalVariables.gWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: CoreColor().appGreen,
              width: 1,
            ),
            color: CoreColor().grey,
          ),
          child: const Icon(
            Icons.account_circle_sharp,
            size: 200,
          ),
        ),
        const SizedBox(height: 20),
        MaterialButton(
          color: CoreColor().grey,
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.upload,
                color: CoreColor().appGreen,
                size: 25,
              ),
              Text(
                'Upload Photo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: CoreColor().appGreen,
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: GlobalVariables.gWidth,
          child: MaterialButton(
            color: CoreColor().appGreen,
            child: Text(
              'Continue',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1,
            ),
            onPressed: () {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  Widget facialRecog() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: IconButton(
                iconSize: 30,
                onPressed: () {
                  setState(() {
                    screenChange(1);
                  });
                },
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
            ),
            const SizedBox(width: 55),
            const SizedBox(
              width: 200,
              child: Text(
                'Facial Recognition',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 50),
        Container(
          alignment: Alignment.center,
          width: GlobalVariables.gWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.transparent,
          ),
          child: Icon(
            Icons.account_circle_sharp,
            size: 250,
            color: CoreColor().grey,
          ),
        ),
        const Text(
          'We will now confirm your identity. Face the camera and follow the on-screen instructions to begin.',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: GlobalVariables.gWidth / 4.5,
              child: Column(
                children: [
                  const Icon(
                    Icons.hdr_auto_outlined,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Avoid wearing hats',
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyText2,
                  )
                ],
              ),
            ),
            SizedBox(
              width: GlobalVariables.gWidth / 4.5,
              child: Column(
                children: const [
                  Icon(
                    Icons.hdr_auto_outlined,
                    size: 60,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Avoid wearing glasses',
                    textAlign: TextAlign.center,
                    style: TextStyle(),
                  )
                ],
              ),
            ),
            SizedBox(
              width: GlobalVariables.gWidth / 4.5,
              child: Column(
                children: const [
                  Icon(
                    Icons.hdr_auto_outlined,
                    size: 60,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Avoid using filters',
                    textAlign: TextAlign.center,
                    style: TextStyle(),
                  )
                ],
              ),
            ),
            SizedBox(
              width: GlobalVariables.gWidth / 4.5,
              child: Column(
                children: const [
                  Icon(
                    Icons.hdr_auto_outlined,
                    size: 60,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Avoid enough lighting',
                    textAlign: TextAlign.center,
                    style: TextStyle(),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: GlobalVariables.gWidth,
          child: MaterialButton(
            color: CoreColor().appGreen,
            child: Text(
              'Continue',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1,
            ),
            onPressed: () {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }
}
