import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_scanner/models/tender.dart';
import 'package:flutter_scanner/models/user.dart';

class DatabaseService {
  final String uid;
  final String data;

  DatabaseService({this.uid, this.data});

  final CollectionReference tendersCollection =
      FirebaseFirestore.instance.collection('t');
  final CollectionReference logCollection =
      FirebaseFirestore.instance.collection('l');
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference appVersion =
      FirebaseFirestore.instance.collection('version');

  Future updateUsersList(String userUid, String userEmail, String userName,
      String userSection) async {
    // ignore: deprecated_member_use
    return await usersCollection.document(uid).setData({
      'uid': uid,
      'email': userEmail,
      'userName': userName,
      'userSection': userSection
    });
  }

  Future updateTenderData(
      String tenderNumber,
      String tenderName,
      String tenderLocation,
      String tenderSection,
      String tenderOwnerName,
      String tenderDirection,
      String currentEmployee,
      String currentTime,
      String actionOnTender) async {
    // ignore: deprecated_member_use
    return await tendersCollection.document(data).setData({
      'tenderNumber': tenderNumber,
      'tenderName': tenderName,
      'tenderOwnerName': tenderOwnerName,
      'tenderSection': tenderSection,
      'tenderLocation': tenderLocation,
      'currentEmployee': currentEmployee,
      'tenderDirection': tenderDirection,
      'currentTime': currentTime,
      'actionOnTender': actionOnTender,
    });
  }

  Future addNewTenderData(
      String tenderNumber,
      String tenderName,
      String tenderLocation,
      String tenderSection,
      String tenderOwnerName,
      String tenderDirection,
      String currentEmployee,
      String currentTime,
      String actionOnTender) async {
    // ignore: deprecated_member_use
    return await tendersCollection.document(data).setData({
      'tenderNumber': tenderNumber,
      'tenderName': tenderName,
      'tenderOwnerName': tenderOwnerName,
      'tenderSection': tenderSection,
      'tenderLocation': tenderLocation,
      'currentEmployee': currentEmployee,
      'tenderDirection': tenderDirection,
      'currentTime': currentTime,
      'actionOnTender': actionOnTender,
    });
  }

  Future deleteTenderData(String tenderNumber) async {
    // ignore: deprecated_member_use
    return await tendersCollection.document(data).delete();
  }

  Future updateLogFile(
      String tenderNumber,
      String tenderName,
      String tenderLocation,
      String tenderSection,
      String tenderOwnerName,
      String tenderDirection,
      String currentEmployee,
      String currentTime,
      String actionOnTender) async {
    // ignore: deprecated_member_use
    return await logCollection
        // ignore: deprecated_member_use
        .document(data)
        .collection(currentTime.replaceAll('/', ''))
        // ignore: deprecated_member_use
        .doc(actionOnTender)
        // ignore: deprecated_member_use
        .setData({
      'tenderNumber': tenderNumber,
      'tenderName': tenderName,
      'tenderOwnerName': tenderOwnerName,
      'tenderSection': tenderSection,
      'tenderLocation': tenderLocation,
      'currentEmployee': currentEmployee,
      'tenderDirection': tenderDirection,
      'currentTime': currentTime,
      'actionOnTender': actionOnTender,
    });
  }

  // tender list from snapshot
  List<Tender> _tenderListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      //print(doc.data);
      return Tender(
          tenderNumber: doc.data()['tenderNumber'] ?? 'should be specified',
          tenderName: doc.data()['tenderName'] ?? 'should be specified',
          tenderOwnerName:
              doc.data()['tenderOwnerName'] ?? 'should be specified',
          currentEmployee:
              doc.data()['currentEmployee'] ?? 'should be specified',
          tenderSection: doc.data()['tenderSection'] ?? 'should be specified',
          currentTime: doc.data()['currentTime'] ?? 'should be specified',
          tenderDirection: doc.data()['tenderDirection'] ?? 'inward',
          tenderLocation:
              doc.data()['tenderLocation'] ?? 'should be specified');
    }).toList();
  }

  //
  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    //print(snapshot.data()['userName']);
    return UserData(
      uid: snapshot.data()['uid'],
      userName: snapshot.data()['userName'],
      userSection: snapshot.data()['userSection'],
    );
  }

  Stream<List<Tender>> get tenders {
    return tendersCollection.snapshots().map(_tenderListFromSnapshot);
  }

  //
  // get user doc stream
  Stream<UserData> get userData {
    return usersCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  Stream<String> get currentAppVersion {
    
    return appVersion.doc('version').snapshots().map((event) => event.data()['version']);
  }
}
