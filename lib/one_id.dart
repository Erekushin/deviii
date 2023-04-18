import 'dart:developer';

import 'package:bip39/bip39.dart' as bip39;
import 'package:devita/helpers/gvariables.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hex/hex.dart';
import 'package:convert/convert.dart';
import 'package:web3dart/credentials.dart';

class AddressService {
  Future<bool> importFromMnemonic(String mnemonic) async {
    try {
      print("sdaaaaaaaaaaaaa: ${_validateMnemonic(mnemonic)}");
      if (_validateMnemonic(mnemonic) == true) {
        final normalisedMnemonic = _mnemonicNormalise(mnemonic);
        await setupFromMnemonic(normalisedMnemonic);
        return true;
      } else {
        print('wtf');
      }
    } catch (e) {
      print("EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEe");
    }
    return false;
  }

  Future<bool> setupFromMnemonic(String mnemonic) async {
    final cryptMnemonic = bip39.mnemonicToEntropy(mnemonic);
    final privateKey = await getPrivateKey(mnemonic);
    final getAddress = await getPublicAddress(privateKey);

    var storage = GetStorage();
    storage.write('cryptMnemonic', cryptMnemonic);
    storage.write('privateKey', privateKey);
    storage.write('getAddress', getAddress.toString());

    print('end iors: ${storage.read('getAddress')}');
    return true;
  }

  Future<String> getPrivateKey(String mnemonic) async {
    final seed = bip39.mnemonicToSeedHex(mnemonic);
    final master = await ED25519_HD_KEY.getMasterKeyFromSeed(hex.decode(seed),
        masterSecret: 'Bitcoin seed');
    final privateKey = HEX.encode(master.key);

    return privateKey;
  }

  Future<EthereumAddress> getPublicAddress(String privateKey) async {
    final private = EthPrivateKey.fromHex(privateKey);
    final address = await private.extractAddress();
    // var storage = GetStorage();

    // storage.write('getAddress', address);
    return address;
  }

  String _mnemonicNormalise(String mnemonic) {
    return _mnemonicWords(mnemonic).join(' ');
  }

  bool _validateMnemonic(String mnemonic) {
    return _mnemonicWords(mnemonic).length == 12;
  }

  List<String> _mnemonicWords(String mnemonic) {
    return mnemonic
        .split(' ')
        .where((item) => item.trim().isNotEmpty)
        .map((item) => item.trim())
        .toList();
  }

  Future<bool> setupFromPrivateKey(String privateKey) async {
    // await _configService.setPrivateKey(privateKey);
    print("privateKey: $privateKey");

    return true;
  }
}
