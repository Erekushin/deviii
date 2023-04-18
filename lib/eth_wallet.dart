import 'package:devita/helpers/gextensions.dart';
import 'package:devita/helpers/global_words.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/one_id.dart';
import 'package:devita/screens/login/devita_sign_up.dart';
import 'package:devita/screens/main_tab.dart';
import 'package:devita/services/services.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:get/get.dart';
import 'package:hex/hex.dart';
import 'package:convert/convert.dart';
import 'package:flutter/services.dart';
import 'dart:convert' as convert;

class EthWalletConnect extends StatefulWidget {
  const EthWalletConnect({
    Key? key,
    required this.type,
  }) : super(key: key);
  final bool type;

  @override
  _EthWalletConnectState createState() => _EthWalletConnectState();
}

class _EthWalletConnectState extends State<EthWalletConnect> {
  RxString setMnemonic = 'setMnemonic'.obs;
  RxString setPrivateKey = 'setPrivateKey'.obs;
  RxBool setupDone = false.obs;
  RxString address = 'address'.obs;
  RxBool screenChange = false.obs;
  RxBool check = false.obs;
  String warning =
      'Get a piece of papper, write down your seed phrase \n and keep it safe. This is the only way to recover your \n funds.';

  var textController = TextEditingController();
  var textController1 = TextEditingController();
  @override
  void initState() {
    super.initState();
    generateMnemonic();
  }

  generateMnemonic() {
    print("bip39.generateMnemonic(): ${bip39.generateMnemonic()}");
    textController.text = bip39.generateMnemonic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'r101347'.coreTranslationWord(),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => screenChange.value == false ? generateScreen() : submitScreen(),
      ),
    );
  }

  Widget generateScreen() {
    return Column(
      children: [
        const SizedBox(height: 30),
        Text(
          warning,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: GlobalVariables.gWidth - 50,
          child: TextFormField(
            enabled: false,
            controller: textController,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                setState(() {
                  print('connect: ${textController.text}');
                  Clipboard.setData(ClipboardData(text: textController.text));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Copied'),
                  ));
                });
              },
              child: Text(
                'r101349'.coreTranslationWord(),
              ),
            ),
            const SizedBox(width: 20),
            MaterialButton(
              color: CoreColor().appGreen,
              onPressed: () {
                setState(() {
                  screenChange.value = true;
                });
              },
              child: Text(
                'r101350'.coreTranslationWord(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget submitScreen() {
    return Column(
      children: [
        const SizedBox(height: 50),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: TextFormField(
            controller: textController1,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
          ),
        ),
        const SizedBox(height: 20),
        MaterialButton(
          minWidth: GlobalVariables.gWidth - 80,
          color: CoreColor().appGreen,
          onPressed: () {
            setState(() {
              if (textController1.text == '') {
                Get.snackbar(
                  gWarning,
                  'Please fill in the field!',
                  colorText: Colors.black,
                );
              } else {
                confirmMnemonic(textController1.text);
              }
            });
          },
          child: Text(
            'r101294'.coreTranslationWord(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Obx(
          () => check.value == false
              ? Container()
              : const Text(
                  'Invalid mnemonic, please try again.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
        )
      ],
    );
  }

  Future<bool> confirmMnemonic(String mnemonic) async {
    if (textController.text != mnemonic) {
      print("Invalid mnemonic, please try again.");
      check.value = true;
      return false;
    }
    // _store.dispatch(WalletSetupStarted());
    await setupFromMnemonic(mnemonic);
    return true;
  }

  Future<bool> setupFromMnemonic(String mnemonic) async {
    final cryptMnemonic = bip39.mnemonicToEntropy(mnemonic);
    final privateKey = await getPrivateKey(mnemonic);

    print("cryptMnemonic: $cryptMnemonic");
    print("privateKey: $privateKey");

    Get.snackbar(
      gSuccess,
      'Success',
      colorText: Colors.black,
    );
    if (widget.type == true) {
      Get.to(() => const DevitaSignup());
    } else {
      print('wtf');

      final address = await AddressService().getPublicAddress(privateKey);
      GlobalVariables.connectOneId(address, 2);

      // var bodyData = {
      //   "one_id": address.toString(),
      // };
      // print(bodyData);

      // Services()
      //     .postRequest(convert.json.encode(bodyData),
      //         'https://backend.devita.mn/auth/user/profile/update/oneid', true)
      //     .then((data) {
      //   var res = convert.json.decode(data.body);
      //   if (res['code'] == 200) {
      //     Get.to(() => const MainTab());

      //     Get.snackbar(
      //       gSuccess,
      //       res['message'],
      //       colorText: Colors.black,
      //     );
      //   } else {
      //     Get.snackbar(
      //       gWarning,
      //       res['message'],
      //       colorText: Colors.black,
      //     );
      //   }
      // });
    }

    return true;
  }

  Future<String> getPrivateKey(String mnemonic) async {
    print(mnemonic);
    final seed = bip39.mnemonicToSeedHex(mnemonic);
    print('seed: $seed');
    final master = await ED25519_HD_KEY.getMasterKeyFromSeed(hex.decode(seed),
        masterSecret: 'Bitcoin seed');
    print("master: ${master.key} :chain: ${master.chainCode}");
    final privateKey = HEX.encode(master.key);
    print('private: $privateKey');
    return privateKey;
  }

  Future<bool> importFromPrivateKey(String privateKey) async {
    try {
      // _store.dispatch(WalletSetupStarted());
      print('manlai: ');
      await setupFromPrivateKey(privateKey);
      return true;
    } catch (e) {
      print("importFromPrivateKey err: $e");
    }
    return false;
  }

  Future<bool> setupFromPrivateKey(String privateKey) async {
    print("setupFromPrivateKey: $privateKey");
    // await _configService.setMnemonic(null);
    // await _configService.setPrivateKey(privateKey);
    // await _configService.setupDone(true);
    return true;
  }
}
