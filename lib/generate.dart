//
//
// import 'package:flutter/material.dart';
// //import 'package:qr_flutter/qr_flutter.dart';
// import 'dart:ui';
// import 'package:flutter/rendering.dart';
//
// class GeneratePage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => GeneratePageState();
// }
//
// class GeneratePageState extends State<GeneratePage> {
//   String qrData =
//       "https://github.com/neon97";  // already generated qr code when the page opens
//   double spaceWidth = 100;
//   double spaceHeight = 100;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('QR Code Generator'),
//         actions: <Widget>[],
//       ),
//       body: Container(
//         padding: EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             QrImage(
//               //plce where the QR Image will be shown
//               data: qrData,
//               size: spaceHeight,
//             ),
//             SizedBox(
//               height: 10.0,
//             ),
//             Text(
//               "New QR Link Generator",
//               style: TextStyle(fontSize: 20.0),
//             ),
//             TextField(
//               controller: qrdataFeed,
//               decoration: InputDecoration(
//                 hintText: "Input your link or data",
//               ),
//              onTap: () {
//                 setState(() {
//                   spaceHeight = MediaQuery.of(context).size.height/5;
//                 });
//              },
//             ),
//             Padding(
//               padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
//               child: FlatButton(
//                 padding: EdgeInsets.all(15.0),
//                 onPressed: () async {
//
//                   if (qrdataFeed.text.isEmpty) {        //a little validation for the textfield
//                     setState(() {
//                       qrData = "";
//                     });
//                   } else {
//                     setState(() {
//                       qrData = qrdataFeed.text;
//                     });
//                   }
//
//                 },
//                 child: Text(
//                   "Generate QR",
//                   style: TextStyle(
//                       color: Colors.blue, fontWeight: FontWeight.bold),
//                 ),
//                 shape: RoundedRectangleBorder(
//                     side: BorderSide(color: Colors.blue, width: 3.0),
//                     borderRadius: BorderRadius.circular(20.0)),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   final qrdataFeed = TextEditingController();
// }
