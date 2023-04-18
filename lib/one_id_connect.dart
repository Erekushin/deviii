import 'dart:async';
import 'dart:convert';
import 'package:devita/eth_wallet.dart';
import 'package:devita/helpers/gextensions.dart';
import 'package:devita/helpers/global_words.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/one_id.dart';
import 'package:devita/services/services.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OneIdConnect extends StatefulWidget {
  const OneIdConnect({Key? key}) : super(key: key);

  @override
  _OneIdConnectState createState() => _OneIdConnectState();
}

class _OneIdConnectState extends State<OneIdConnect> {
  RxString selectGender = 'SeedPhrade'.obs;
  var oneIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("One ID connection"),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: ListTile(
                    title: const Text(
                      'Seed Phrade',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    leading: Obx(() => Radio(
                          value: "SeedPhrade",
                          groupValue: selectGender.value,
                          activeColor: CoreColor().appGreen,
                          onChanged: (String? value) {
                            setState(() {
                              oneIdController.text = '';
                              selectGender.value = value!;
                            });
                          },
                        )),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ListTile(
                    title: const Text(
                      'Private Key',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    leading: Obx(() => Radio(
                          value: "PrivateKey",
                          groupValue: selectGender.value,
                          activeColor: CoreColor().appGreen,
                          onChanged: (String? value) {
                            setState(() {
                              oneIdController.text = '';
                              selectGender.value = value!;
                            });
                          },
                        )),
                  ),
                ),
              ],
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              controller: oneIdController,
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () {
                var storage = GetStorage();

                setState(() {
                  if (oneIdController.text != '') {
                    if (selectGender.value == 'SeedPhrade') {
                      AddressService().importFromMnemonic(oneIdController.text);
                      GlobalVariables.connectOneId(
                          storage.read('getAddress'), 1);
                    } else {
                      AddressService().getPublicAddress(oneIdController.text);
                      GlobalVariables.connectOneId(
                          storage.read('getAddress'), 1);
                    }
                  } else {
                    Get.snackbar(
                      gWarning,
                      'Please fill in the field !',
                      colorText: Colors.black,
                    );
                  }
                });
              },
              child: Text(
                'r101351'.coreTranslationWord(),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(bottom: 0),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EthWalletConnect(type: false),
                      ),
                    );
                  });
                },
                child: Text(
                  'r101347'.coreTranslationWord(),
                  style: TextStyle(
                    color: CoreColor().appGreen,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
