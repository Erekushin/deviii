import 'dart:convert';
import 'dart:io' show Platform;
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/one_id_connect.dart';
import 'package:devita/screens/home/settings_page.dart';
import 'package:devita/screens/my_devita/my_devita.dart';
import 'package:devita/screens/user_views/doctor/doctor_list.dart';
import 'package:devita/screens/user_views/wallet/eth_conversions.dart';
import 'package:devita/screens/user_views/wallet/qr_scanner.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_polygon/flutter_polygon.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallet_connect/models/ethereum/wc_ethereum_sign_message.dart';
import 'package:wallet_connect/models/ethereum/wc_ethereum_transaction.dart';
import 'package:wallet_connect/models/session/wc_session.dart';
import 'package:wallet_connect/models/wc_peer_meta.dart';
import 'package:wallet_connect/wc_client.dart';
import 'package:wallet_connect/wc_session_store.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:devita/helpers/gextensions.dart';
import 'package:http/http.dart' as http;
import './wallet_test.dart';

const maticRpcUri =
    'https://rpc-mainnet.maticvigil.com/v1/140d92ff81094f0f3d7babde06603390d7e581be';

class HomePage extends StatefulWidget {
  // final ScannerDelegate scannerProtocol;
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  // late ScannerDelegate scannerDelegate;
  int selectedindex = 0;
  bool body = false;

  late WCClient _wcClient;
  // late InAppWebViewController _webViewController;
  late String walletAddress, privateKey;
  WCSessionStore? _sessionStore;
  bool connected = false;

  var storage = GetStorage();
  late TextEditingController _textEditingController;
  RxString addressConnector = ''.obs;
  List items = [
    {
      "title": 'r101081'.coreTranslationWord(),
      "desc": 'r101086'.coreTranslationWord(),
      "url": "my_devita.png"
    },
    {
      "title": 'r101082'.coreTranslationWord(),
      "desc": 'r101087'.coreTranslationWord(),
      "url": "telehealth.png"
    },
    {
      "title": 'r101084'.coreTranslationWord(),
      "desc": 'r101088'.coreTranslationWord(),
      "url": "settings.png"
    },
    {
      "title": 'r101093'.coreTranslationWord(),
      "desc": 'r101094'.coreTranslationWord(),
      "url": 'marketplace.png'
    },
  ];

  final _web3client = Web3Client(
    maticRpcUri,
    http.Client(),
  );

  get ethSigUtil => null;
  final wc = WalletConnector();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  _initialize() async {
    _wcClient = WCClient(
      onSessionRequest: _onSessionRequest,
      onFailure: _onSessionError,
      onDisconnect: _onSessionClosed,
      onEthSign: _onSign,
      onEthSignTransaction: _onSignTransaction,
      onEthSendTransaction: _onSendTransaction,
      onCustomRequest: (_, __) {},
      onConnect: _onConnect,
    );
    walletAddress = '0x24c20f6a571052ac72e352db638a889be704aaec';
    privateKey =
        'abd302254f05e96ac461b6c7b4365222e29d4798fa2a0996017b70967746c5fa';
    _textEditingController = TextEditingController();
  }

  _onConnect() {
    setState(() {
      connected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center, //
      children: [
        Positioned(
          child: Container(
            margin: const EdgeInsets.only(left: 30),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  print(selectedindex);
                  switch (selectedindex) {
                    case 0:
                      Get.to(() => const MyDevita());
                      break;
                    case 1:
                      Get.to(() => const DoctorList());
                      break;
                    case 2:
                      Get.to(() => const SettingsPage());
                      break;
                    case 3:
                      modal();
                      break;
                    default:
                  }
                });
              },
              child: ListWheelScrollView.useDelegate(
                itemExtent: 200,
                // useMagnifier: false,
                overAndUnderCenterOpacity: 0.5,
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedindex = index;
                  });
                },
                magnification: 1,
                diameterRatio: 2.5,
                squeeze: 0.9,
                offAxisFraction: -1.5,
                perspective: 0.003,
                scrollBehavior: const ScrollBehavior(),
                physics: const FixedExtentScrollPhysics(),
                childDelegate: ListWheelChildBuilderDelegate(
                    childCount: items.length,
                    builder: (BuildContext context, int index) {
                      return Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 60),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  items[index]['title'],
                                  style: const TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    items[index]['desc'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          ClipPolygon(
                            sides: 6,
                            borderRadius: 8.0,
                            rotate: 60.0,
                            boxShadows: [
                              PolygonBoxShadow(
                                  color: CoreColor().appGreen, elevation: 5.0)
                            ],
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    "assets/images/" + items[index]['url'],
                                  ),
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    }),
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: GestureDetector(
            onTap: null,
            onPanUpdate: (details) {
              if (details.delta.dx < 0) {
                setState(() {
                  showDialogCustom();
                });
              }
            },
            child: Container(
              height: 130,
              decoration: BoxDecoration(
                color: CoreColor().appGreen,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                ),
              ),
              child: const Icon(
                Icons.arrow_left,
                color: Colors.black,
                size: 40,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// [showDialogCustom] right action modal
  showDialogCustom() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.white.withOpacity(0.4),
      transitionDuration: const Duration(milliseconds: 200),
      context: context,
      pageBuilder: (_, __, ___) {
        return Obx(
          () => Align(
            alignment: Alignment.center,
            child: GlobalVariables.connectionType.value == false
                ? disconnectWallet()
                : connectionWallet(),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: const Offset(0, 0))
              .animate(anim),
          child: child,
        );
      },
    );
  }

  Widget connectionWallet() {
    return Container(
      margin: const EdgeInsets.only(left: 60),
      height: GlobalVariables.gHeight / 1.6,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          left: BorderSide(
            color: CoreColor().appGreen,
            width: 2.0,
          ),
          top: BorderSide(
            color: CoreColor().appGreen,
            width: 2.0,
          ),
          bottom: BorderSide(
            color: CoreColor().appGreen,
            width: 2.0,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(color: CoreColor().appbarColor),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                child: TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Icon(
                        Icons.select_all_outlined,
                        color: CoreColor().appGreen,
                        size: 25,
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => QrImage(
                  data: addressConnector.value,
                  size: 120,
                  errorCorrectionLevel: QrErrorCorrectLevel.Q,
                  gapless: true,
                  version: QrVersions.auto,
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                GlobalVariables.firstName.capitalizeCustom() +
                    ' ' +
                    GlobalVariables.lastName.capitalizeCustom(),
                style: const TextStyle(
                  decoration: TextDecoration.none,
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                '0 ETH',
                style: TextStyle(
                  color: CoreColor().appGreen,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(
                child: TextButton(
                  onPressed: () {},
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () => SizedBox(
                          width: 150,
                          child: Text(
                            addressConnector.value,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 3),
                      Icon(
                        Icons.copy,
                        color: CoreColor().appGreen,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: GlobalVariables.gWidth - 250,
                color: Colors.black12,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: MaterialButton(
                            color: CoreColor().appGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: CoreColor().appGreen),
                            ),
                            onPressed: () {
                              setState(() {});
                            },
                            child: Text(
                              'r101036'.coreTranslationWord(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Divider(color: Colors.grey, height: 3),
              const SizedBox(height: 5),
              TextButton(
                child: Text(
                  'r101084'.coreTranslationWord(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                ),
                onPressed: () {},
              ),
              const SizedBox(height: 5),
              const Divider(color: Colors.grey, height: 3),
              const SizedBox(height: 5),
              TextButton(
                child: Text(
                  'r101298'.coreTranslationWord(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    print('dis');
                    // GlobalVariables.connectionType.value = false;
                    // Get.back();
                    // // Kill the session
                    // wc.connector.killSession();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget disconnectWallet() {
    return Container(
      height: 300,
      width: GlobalVariables.gWidth - 50,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        children: [
          const SizedBox(height: 19),
          SizedBox(
            width: GlobalVariables.gWidth - 90,
            child: MaterialButton(
              color: CoreColor().grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              onPressed: () async {
                print('dsadsadsadadsadads');
                // Get.to(() => const ConnectedWallets());
                final session = await wc.connector.createSession(
                  chainId: 3,
                  onDisplayUri: (uri) {
                    setState(() {
                      launch(uri).then(
                        (bool isLaunch) {
                          print('isLaunch: $isLaunch');
                          if (isLaunch) {
                            // Launch Success
                            print('sucscscscsw');
                          } else {
                            // Launch Fail
                            print('elselsesesl');
                          }
                        },
                        onError: (e) {
                          print('onError: $e');
                          errorModal();
                        },
                      );
                    });
                  },
                );
                print("session: $session");
                print(session.accounts[0].toString());
                setState(() {
                  addressConnector.value = session.accounts[0].toString();
                });
                Get.back();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/WalletConnect.png',
                    height: 40,
                    // width: 280,
                  ),
                  // const SizedBox(width: 20),
                  // Text(
                  //   'r101096'.coreTranslationWord(),
                  //   style: const TextStyle(
                  //     color: Colors.white,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: GlobalVariables.gWidth - 90,
            child: MaterialButton(
              color: CoreColor().grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              onPressed: () {},
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/MoonWallet.png',
                    height: 40,
                    // width: 280,
                  ),
                  // const SizedBox(width: 20),
                  // Text(
                  //   'r101097'.coreTranslationWord(),
                  //   style: const TextStyle(
                  //     color: Colors.white,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 20),
              Expanded(
                child: MaterialButton(
                  color: CoreColor().appGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onPressed: () {
                    setState(() {
                      print('dolldwd');
                    });
                  },
                  child: Text(
                    'r101098'.coreTranslationWord(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QRScanView()),
                    ).then((value) {
                      if (value != null) {
                        _qrScanHandler(value);
                      }
                    });
                  },
                  color: CoreColor().appGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text('r101100'.coreTranslationWord()),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OneIdConnect()),
              );
            },
            child: Text(
              'r101299'.coreTranslationWord(),
              style: TextStyle(
                color: CoreColor().appGreen,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _qrScanHandler(String value) {
    final session = WCSession.from(value);
    debugPrint('test $session');
    final peerMeta = WCPeerMeta(
      name: "Devita wallet",
      url: "https://devita.wallet",
      description: "Devita Wallet",
      icons: [
        "https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png"
      ],
    );
    _wcClient.connectNewSession(session: session, peerMeta: peerMeta);
  }

  _onSessionRequest(int id, WCPeerMeta peerMeta) {
    showDialog(
      context: context,
      builder: (_) {
        return SimpleDialog(
          title: Column(
            children: [
              if (peerMeta.icons.isNotEmpty)
                Container(
                  height: 100.0,
                  width: 100.0,
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.network(peerMeta.icons.first),
                ),
              Text(peerMeta.name),
            ],
          ),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
          children: [
            if (peerMeta.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(peerMeta.description),
              ),
            if (peerMeta.url.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Connection to ${peerMeta.url}'),
              ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () async {
                      _wcClient.approveSession(
                        accounts: [walletAddress],
                        // TODO: Mention Chain ID while connecting
                        chainId: 3,
                      );
                      _sessionStore = _wcClient.sessionStore;
                      await storage.write('session',
                          jsonEncode(_wcClient.sessionStore.toJson()));
                      Navigator.pop(context);
                    },
                    child: Text(
                      'r101159'.coreTranslationWord(),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () {
                      _wcClient.rejectSession();
                      Navigator.pop(context);
                    },
                    child: Text('r101300'.coreTranslationWord()),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  _onSessionError(dynamic message) {
    setState(() {
      connected = false;
    });
    showDialog(
      context: context,
      builder: (_) {
        return SimpleDialog(
          title: Text('m101008'.coreTranslationWord()),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text('Some Error Occured. $message'),
            ),
            Row(
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('m101003'.coreTranslationWord()),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  _onSessionClosed(int? code, String? reason) {
    storage.remove('session');
    setState(() {
      connected = false;
    });
    showDialog(
      context: context,
      builder: (_) {
        return SimpleDialog(
          title: Text(
            'r101301'.coreTranslationWord(),
          ),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text('Some Error Occured. ERROR CODE: $code'),
            ),
            if (reason != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Failure Reason: $reason'),
              ),
            Row(
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('m101003'.coreTranslationWord()),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  _onSignTransaction(
    int id,
    WCEthereumTransaction ethereumTransaction,
  ) {
    _onTransaction(
      id: id,
      ethereumTransaction: ethereumTransaction,
      title: 'Sign Transaction',
      onConfirm: () async {
        final creds = EthPrivateKey.fromHex(privateKey);
        final tx = await _web3client.signTransaction(
          creds,
          _wcEthTxToWeb3Tx(ethereumTransaction),
          chainId: _wcClient.chainId!,
        );
        // final txhash = await _web3client.sendRawTransaction(tx);
        // debugPrint('txhash $txhash');//
        _wcClient.approveRequest<String>(
          id: id,
          result: bytesToHex(tx),
        );
        Navigator.pop(context);
      },
      onReject: () {
        _wcClient.rejectRequest(id: id);
        Navigator.pop(context);
      },
    );
  }

  _onSendTransaction(
    int id,
    WCEthereumTransaction ethereumTransaction,
  ) {
    _onTransaction(
      id: id,
      ethereumTransaction: ethereumTransaction,
      title: 'Send Transaction',
      onConfirm: () async {
        final creds = EthPrivateKey.fromHex(privateKey);
        final txhash = await _web3client.sendTransaction(
          creds,
          _wcEthTxToWeb3Tx(ethereumTransaction),
          chainId: _wcClient.chainId!,
        );
        debugPrint('txhash $txhash');
        _wcClient.approveRequest<String>(
          id: id,
          result: txhash,
        );
        Navigator.pop(context);
      },
      onReject: () {
        _wcClient.rejectRequest(id: id);
        Navigator.pop(context);
      },
    );
  }

  _onTransaction({
    required int id,
    required WCEthereumTransaction ethereumTransaction,
    required String title,
    required VoidCallback onConfirm,
    required VoidCallback onReject,
  }) async {
    ContractFunction? contractFunction;
    BigInt gasPrice = BigInt.parse(ethereumTransaction.gasPrice ?? '0');
    try {
      final abiUrl =
          'https://api.polygonscan.com/api?module=contract&action=getabi&address=${ethereumTransaction.to}&apikey=BCER1MXNFHP1TVE93CMNVKC5J4FV8R4CPR';
      final res = await http.get(Uri.parse(abiUrl));
      final Map<String, dynamic> resMap = jsonDecode(res.body);
      final abi = ContractAbi.fromJson(resMap['result'], '');
      final contract = DeployedContract(
          abi, EthereumAddress.fromHex(ethereumTransaction.to));
      final dataBytes = hexToBytes(ethereumTransaction.data);
      final funcBytes = dataBytes.take(4).toList();
      debugPrint("funcBytes $funcBytes");
      final maibiFunctions = contract.functions
          .where((element) => listEquals<int>(element.selector, funcBytes));
      if (maibiFunctions.isNotEmpty) {
        debugPrint("isNotEmpty");
        contractFunction = maibiFunctions.first;
        debugPrint("function ${contractFunction.name}");
        // contractFunction.parameters.forEach((element) {
        //   debugPrint("params ${element.name} ${element.type.name}");
        // });
        // final params = dataBytes.sublist(4).toList();
        // debugPrint("params $params ${params.length}");
      }
      if (gasPrice == BigInt.zero) {
        gasPrice = await _web3client.estimateGas();
      }
    } catch (e, trace) {
      debugPrint("failed to decode\n$e\n$trace");
    }
    showDialog(
      context: context,
      builder: (_) {
        return SimpleDialog(
          title: Column(
            children: [
              if (_wcClient.remotePeerMeta!.icons.isNotEmpty)
                Container(
                  height: 100.0,
                  width: 100.0,
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.network(_wcClient.remotePeerMeta!.icons.first),
                ),
              Text(
                _wcClient.remotePeerMeta!.name,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'r101302'.coreTranslationWord(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    '{ethereumTransaction.to}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'r101304'.coreTranslationWord(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${EthConversions.weiToEthUnTrimmed(gasPrice * BigInt.parse(ethereumTransaction.gas ?? '0'), 18)} MATIC',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'r101303'.coreTranslationWord(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${EthConversions.weiToEthUnTrimmed(BigInt.parse(ethereumTransaction.value ?? '0'), 18)} MATIC',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
            if (contractFunction != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'r101305'.coreTranslationWord(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      contractFunction.name,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    'r101306'.coreTranslationWord(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  children: [
                    Text(
                      ethereumTransaction.data,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: onConfirm,
                    child: Text(
                      'r101307'.coreTranslationWord(),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: onReject,
                    child: Text(
                      'r101300'.coreTranslationWord(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  _onSign(
    int id,
    WCEthereumSignMessage ethereumSignMessage,
  ) {
    final decoded = (ethereumSignMessage.type == WCSignType.TYPED_MESSAGE)
        ? ethereumSignMessage.data!
        : ascii.decode(hexToBytes(ethereumSignMessage.data!));
    showDialog(
      context: context,
      builder: (_) {
        return SimpleDialog(
          title: Column(
            children: [
              if (_wcClient.remotePeerMeta!.icons.isNotEmpty)
                Container(
                  height: 100.0,
                  width: 100.0,
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.network(_wcClient.remotePeerMeta!.icons.first),
                ),
              Text(
                _wcClient.remotePeerMeta!.name,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'r101308'.coreTranslationWord(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    'r101309'.coreTranslationWord(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  children: [
                    Text(
                      decoded,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () async {
                      String signedDataHex;
                      if (ethereumSignMessage.type ==
                          WCSignType.TYPED_MESSAGE) {
                        var TypedDataVersion;
                        signedDataHex = ethSigUtil.signTypedData(
                          privateKey: privateKey,
                          jsonData: ethereumSignMessage.data!,
                          version: TypedDataVersion.V4,
                        );
                      } else {
                        final creds = EthPrivateKey.fromHex(privateKey);
                        final encodedMessage =
                            hexToBytes(ethereumSignMessage.data!);
                        final signedData =
                            await creds.signPersonalMessage(encodedMessage);
                        signedDataHex = bytesToHex(signedData, include0x: true);
                      }
                      debugPrint('SIGNED $signedDataHex');
                      _wcClient.approveRequest<String>(
                        id: id,
                        result: signedDataHex,
                      );
                      Navigator.pop(context);
                    },
                    child: Text(
                      'r101310'.coreTranslationWord(),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () {
                      _wcClient.rejectRequest(id: id);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'r101300'.coreTranslationWord(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Transaction _wcEthTxToWeb3Tx(WCEthereumTransaction ethereumTransaction) {
    return Transaction(
      from: EthereumAddress.fromHex(ethereumTransaction.from),
      to: EthereumAddress.fromHex(ethereumTransaction.to),
      maxGas: ethereumTransaction.gasLimit != null
          ? int.tryParse(ethereumTransaction.gasLimit!)
          : null,
      gasPrice: ethereumTransaction.gasPrice != null
          ? EtherAmount.inWei(BigInt.parse(ethereumTransaction.gasPrice!))
          : null,
      value: EtherAmount.inWei(BigInt.parse(ethereumTransaction.value ?? '0')),
      data: hexToBytes(ethereumTransaction.data),
      nonce: ethereumTransaction.nonce != null
          ? int.tryParse(ethereumTransaction.nonce!)
          : null,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<WCSessionStore?>('_sessionStore', _sessionStore));
    properties.add(DiagnosticsProperty<TextEditingController>(
        '_textEditingController', _textEditingController));
    properties.add(IntProperty('selectedindex', selectedindex));
    properties.add(IntProperty('selectedindex', selectedindex));
  }

  modal() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CoreColor().backgroundContainer,
          scrollable: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Column(
            children: [
              Image.asset(
                'assets/images/logo_no_word.png',
                height: 65,
              ),
              const SizedBox(height: 20),
              Text(
                'r101259'.coreTranslationWord(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: CoreColor().appGreen,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: GlobalVariables.gWidth - 80,
                child: MaterialButton(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  color: CoreColor().backgroundNew,
                  child: Text(
                    'r101140'.coreTranslationWord(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  onPressed: () {
                    setState(() {
                      Get.back();
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  errorModal() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CoreColor().backgroundContainer,
          scrollable: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "App not installed",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  SizedBox(
                    width: GlobalVariables.gWidth / 3,
                    child: MaterialButton(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      color: Colors.transparent,
                      child: const Text(
                        'Cancel',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          Get.back();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: GlobalVariables.gWidth / 3,
                    child: MaterialButton(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      color: CoreColor().appGreen,
                      child: const Text(
                        'Download now',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          // Get.back();
                          if (Platform.isAndroid) {
                            print('and');
                            launch(
                                "https://play.google.com/store/apps/details?id=io.metamask&hl=en&gl=US");
                            // Android-specific code
                          } else if (Platform.isIOS) {
                            // iOS-specific code
                            launch(
                                "https://apps.apple.com/us/app/metamask-blockchain-wallet/id1438144202");
                          }
                        });
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
