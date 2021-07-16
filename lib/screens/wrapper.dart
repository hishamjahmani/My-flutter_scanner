import 'package:flutter_scanner/homePage.dart';
import 'package:flutter_scanner/models/tender.dart';
import 'package:flutter_scanner/models/user.dart';
import 'package:flutter_scanner/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scanner/services/database.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //return either Home or Authenticate widget

    final currentUser = Provider.of<AppUser>(context);
    if (currentUser == null) {
      return Authenticate();
    } else {
      return MultiProvider(
        providers: [
          //Provider(create:(context) => DatabaseService().tenders),
          StreamProvider<UserData>(
              create: (_) => DatabaseService(uid: currentUser.uid).userData),
          StreamProvider<List<Tender>>(
              create: (_) => DatabaseService().tenders),
          StreamProvider<String>(
              create: (_) => DatabaseService().currentAppVersion),
        ],
        child: HomePage(),
      );
      // return StreamProvider<UserData>.value(
      //   value: DatabaseService(uid: currentUser.uid).userData,
      //   child: HomePage());
    }
  }
}
