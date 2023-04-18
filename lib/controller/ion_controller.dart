import 'package:flutter_ion/flutter_ion.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';

class IonController extends GetxController {
  GetStorage? _prefs;
  late String _sid;
  late String _name;
  final String _uid = const Uuid().v4();
  IonBaseConnector? _baseConnector;
  IonAppBiz? _biz;
  IonSDKSFU? _sfu;

  String get sid => _sid;

  String get uid => _uid;

  String get name => _name;

  IonAppBiz? get biz => _biz;

  IonSDKSFU? get sfu => _sfu;

  @override
  void onInit() async {
    super.onInit();
    print('IonController::onInit');
  }

  Future<GetStorage> prefs() async {
    if (_prefs == null) {
      await GetStorage.init();
    }
    return _prefs!;
  }

  setup(
      {required String host,
      required String room,
      required String name}) async {
    _baseConnector = IonBaseConnector(host);
    _biz = IonAppBiz(_baseConnector!);
    _sfu = IonSDKSFU(_baseConnector!);
    _sid = room;
    _name = name;
  }

  connect() async {
    await _biz!.connect();
    await _sfu!.connect();
  }

  joinBIZ() async {
    _biz!.join(sid: _sid, uid: _uid, info: {'name': _name});
  }

  joinSFU() async {
    _sfu!.join(_sid, _uid);
  }

  close() async {
    _biz?.leave(_uid);
    _biz?.close();
    _biz = null;
  }
}
