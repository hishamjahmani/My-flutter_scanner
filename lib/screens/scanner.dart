import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

class Scanning extends StatefulWidget {
  const Scanning({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanningState();
}

class _ScanningState extends State<Scanning> {
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  bool x = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: x
                    ? _buildQrView(context)
                    : SizedBox(
                        height: 0,
                      )),
            Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    result != null
                        ? Text(
                            'Barcode Type: ${describeEnum(result.format)}   Data: ${result.code}')
                        : Text('Scan a code'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(8),
                          child: RaisedButton(
                              onPressed: () => setState(() {
                                    controller?.toggleFlash();
                                  }),
                              child: FutureBuilder(
                                future: controller?.getFlashStatus(),
                                builder: (context, snapshot) {
                                  return Text('Flash: ${snapshot.data}');
                                },
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.all(8),
                          child: RaisedButton(
                              onPressed: () => setState(() {
                                    controller?.flipCamera();
                                  }),
                              child: FutureBuilder(
                                future: controller?.getCameraInfo(),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    return Text(
                                        'Camera facing ${describeEnum(snapshot.data)}');
                                  } else {
                                    return Text('loading');
                                  }
                                },
                              )),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(8),
                          child: RaisedButton(
                            onPressed: () {
                              controller?.pauseCamera();
                            },
                            child:
                                Text('pause', style: TextStyle(fontSize: 20)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(8),
                          child: RaisedButton(
                            onPressed: () {
                              controller?.resumeCamera();
                            },
                            child: Text('resume',
                                style: TextStyle(fontSize: 20)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(8),
                          child: RaisedButton(
                            onPressed: () {
                              //await controller?.stopCamera();
                              setState(() {
                                if (x)
                                  controller?.stopCamera();
                                else
                                  controller?.resumeCamera();
                                x = !x;
                              });
                            },
                            child:
                                Text('Stop', style: TextStyle(fontSize: 20)),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 380.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
            key: qrKey,
            cameraFacing: CameraFacing.back,
            onQRViewCreated: _onQRViewCreated,
            formatsAllowed: [BarcodeFormat.qrcode],
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
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

// @override
// void dispose() {
//   controller.dispose();
//   super.dispose();
// }
}
