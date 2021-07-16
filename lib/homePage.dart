import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';

import 'package:flutter_scanner/services/auth.dart';
import 'package:flutter_scanner/services/database.dart';
import 'package:flutter_scanner/shared/constants.dart';
import 'package:flutter_scanner/shared/sectionGridView.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_scanner/tender_list.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'models/user.dart';
import 'models/tender.dart';

import 'package:flutter/services.dart';
import 'shared/constants.dart';

//import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String qrCodeResult = "Ready To Scan...";

  String certainTender, tenderDirection;

  final AuthService _authUser = AuthService();
  final dateFormat = new DateFormat('dd/MM/yyyy hh:mm:ss a');

  bool scan = false;
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String cUserUid, cUserName, cUserSection;
  List<Tender> cTendersList;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    certainTender = '';
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  final TextEditingController searchTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppUser currentUser = Provider.of<AppUser>(context);
    UserData currentUserInfo = Provider.of<UserData>(context);
    List<Tender> currentTendersList = Provider.of<List<Tender>>(context);
    String version = Provider.of<String>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final runningVersion = '0';

    cUserUid = currentUser?.uid;
    cUserSection = currentUserInfo?.userSection;
    cUserName = currentUserInfo?.userName;
    String shortUserName= cUserName?.substring(0,cUserName.length>8? 8: cUserName.length);
    cTendersList= currentTendersList;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome $shortUserName', softWrap: true,),
        centerTitle: false,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('logout'),
            onPressed: () async {
              await _authUser.signOut();
            },
          ),
          //Text('welcome'),
        ],
      ),
      body: (version == runningVersion) ? SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: scan ? screenHeight / 2 : 0,
              width: scan ? screenWidth : 0,
              child: scan
                  ? _buildQrView(context)
                  : SizedBox(
                      height: 0,
                    ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Text(
                  qrCodeResult == 'Ready To Scan...'
                      ? qrCodeResult
                      : 'Scanned File is: $qrCodeResult',
                  style: TextStyle(color: Colors.black, fontSize: 20)),
            ),
            Container(
              width: screenWidth,
              height: 200,
              //padding: EdgeInsets.all(5),
              child:currentTendersList?.length !=0? SectionsGridView(): Image(image: AssetImage('assets/images/logo.jpg')),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: TextFormField(
                controller: searchTextEditingController,
                keyboardType: TextInputType.number,
                decoration: textInputDecoration.copyWith(
                  suffixIcon: certainTender!=''? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              searchTextEditingController.clear();
                              certainTender = '';
                            });
                          }):null,
                    fillColor: Colors.blue[100],
                    hintStyle: TextStyle(color: Colors.red),
                    hintText: 'Search a tender'),
                onChanged: (val) {
                  setState(() => certainTender = val);
                },
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              height: screenHeight-470,
              width: screenWidth,
              child: currentTendersList?.length!=0? TenderList(filter: certainTender,):Image(image: AssetImage('assets/images/logo.jpg')),
            ),
          ],
        ),
      ): Container(child: Center(child: Text('Check the app version', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,)))),
      floatingActionButton: (version == runningVersion) ? FloatingActionButton(
        child: Center(
            child: Text(
          'create',
          style: TextStyle(
            fontSize: 12,
          ),
        )),
        elevation: 25,
        onPressed: () async {
          if(qrCodeResult!="Ready To Scan...") {
            await DatabaseService(uid: cUserUid, data: result.code)
                .addNewTenderData(
              result.code,
              'refrigerator',
              cUserSection,
              cUserSection,
              cUserName,
              tenderDirection,
              cUserName,
              dateFormat.format(DateTime.now()),
              'Created',
            );

            await DatabaseService(uid: cUserUid, data: result.code)
                .updateLogFile(
              result.code,
              'refrigerator',
              cUserSection,
              cUserSection,
              cUserName,
              tenderDirection,
              cUserName,
              dateFormat.format(DateTime.now()),
              'Created',
            );
            setState(() {
              qrCodeResult = "Ready To Scan...";
              controller.resumeCamera();
            });
            FlutterBeep.beep();
          }},
      ): null,
      bottomNavigationBar: (version == runningVersion) ? Container(
        color: Colors.blue[100],
        child: !scan
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FlatButton.icon(
                      icon: Icon(
                        Icons.qr_code_scanner,
                        size: 50,
                        color: Colors.green[400],
                      ),
                      label: Text(
                        'Receive',
                        style: TextStyle(color: Colors.green[400]),
                      ),
                      onPressed: () {
                        setState(() {
                          tenderDirection = 'inward';
                          controller?.resumeCamera();
                          scan = !scan;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FlatButton.icon(
                      icon: Icon(
                        Icons.qr_code_scanner,
                        size: 50,
                        color: Colors.red[400],
                      ),
                      label: Text(
                        'Send',
                        style: TextStyle(color: Colors.red[400]),
                      ),
                      onPressed: () {
                        setState(() {
                          qrCodeResult = 'Ready To Scan...';
                          tenderDirection = 'outward';
                          controller?.resumeCamera();
                          scan = !scan;
                        });
                      },
                    ),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: FlatButton.icon(
                  icon: Icon(
                    Icons.power_settings_new_outlined,
                    size: 50,
                    color: Colors.red[400],
                  ),
                  label: Text(
                    'Close The Scanner',
                    style: TextStyle(color: Colors.red[400]),
                  ),
                  onPressed: () {
                    setState(() {
                      controller?.stopCamera();
                      scan = !scan;
                    });
                  },
                ),
              ),
      ): null,
    ) ;
  }

  Widget flatButton(String text, Widget widget) {
    return FlatButton(
      padding: EdgeInsets.all(15.0),
      onPressed: () async {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => widget));
      },
      child: Text(
        text,
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.blue, width: 3.0),
          borderRadius: BorderRadius.circular(20.0)),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 380.0;

    return QRView(
      key: qrKey,
      cameraFacing: CameraFacing.back,
      onQRViewCreated: _onQRViewCreated,
      formatsAllowed: BarcodeFormat.values,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 35,
        borderLength: 80,
        borderWidth: 10,
        cutOutBottomOffset: 0,
        cutOutSize: scanArea,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
        qrCodeResult = scanData.code;
        controller.pauseCamera();
      });
      //if(!cTendersList.contains(result.code)){
      Tender t;
      for (var i = 0; i < cTendersList.length; i++) {
        if (cTendersList[i].tenderNumber == result.code) {
          t = cTendersList[i];
        }
      }
      //print(t);
      if (t != null) {
        await DatabaseService(uid: cUserUid, data: result.code)
            .updateTenderData(
                result.code,
                t.tenderName,
                cUserSection,
                t.tenderSection,
                t.tenderOwnerName,
                tenderDirection,
                cUserName,
                dateFormat.format(DateTime.now()),
                'Processing');

        await DatabaseService(uid: cUserUid, data: result.code).updateLogFile(
            result.code,
            t.tenderName,
            cUserSection,
            t.tenderSection,
            t.tenderOwnerName,
            tenderDirection,
            cUserName,
            dateFormat.format(DateTime.now()),
            'Processing');

        await FlutterBeep.beep();
        Future.delayed(Duration(milliseconds: 800));
        controller.resumeCamera();
        setState(() {
          qrCodeResult = 'Ready To Scan...';
        });
      } else {
        //FlutterRingtonePlayer.playRingtone();
        await FlutterBeep.playSysSound(44);
        Future.delayed(Duration(milliseconds: 800));
        controller.resumeCamera();
      }
    });
  }
}
