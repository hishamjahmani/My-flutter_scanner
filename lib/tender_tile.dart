import 'package:flutter_scanner/models/tender.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scanner/models/user.dart';
import 'package:flutter_scanner/services/database.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


class TenderTile extends StatelessWidget {
  final Tender tender;

  TenderTile({this.tender});

  @override
  Widget build(BuildContext context) {
    UserData cUser = Provider.of<UserData>(context);
    final dateFormat = new DateFormat('dd/MM/yyyy hh:mm:ss a');

    return Padding(
      padding: const EdgeInsets.only(top: 1.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 10.0,
            backgroundColor: tender.tenderDirection == 'inward'
                ? Colors.green[800]
                : Colors.red[800],

            //backgroundImage: AssetImage('assets/coffee_icon.png'),
          ),
          title: Text(
            tender.tenderNumber,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: Text('${tender.tenderName} at    ${tender.tenderLocation}'),
          onTap: () {
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
                context: context,
                builder: (context) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                    ),
                    height: 300,
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tender Info: ',
                          style: TextStyle(
                            color: Colors.green[800],
                            fontSize: 22.0,
                          ),
                        ),
                        SizedBox(width: 25, height: 10),
                        Text(
                          'Tender No.:   ${tender.tenderNumber}',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(width: 25, height: 10),
                        Text(
                          'Location:   ${tender.tenderLocation}',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(width: 25, height: 10),
                        Text(
                          'Direction:   ${tender.tenderDirection}',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(width: 25, height: 10),
                        Text(
                          'Action Time:   ${tender.currentTime}',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(width: 25, height: 10),
                        Text(
                          'Tender of:   ${tender.tenderOwnerName}',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 18.0,
                          ),
                        ),

                      ],
                    ),
                  );
                });
          },
          onLongPress: () {
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
                context: context,
                builder: (context) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25),),
                          color: Colors.white70,
                    ),
                    height: 300,
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tender Info: ',
                          style: TextStyle(
                            color: Colors.green[800],
                            fontSize: 22.0,
                          ),
                        ),
                        SizedBox(width: 25, height: 10),
                        Text(
                          'Tender No.:   ${tender.tenderNumber}',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(width: 25, height: 10),
                        Text(
                          'Location:   ${tender.tenderLocation}',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(width: 25, height: 10),
                        Text(
                          'Direction:   ${tender.tenderDirection}',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(width: 25, height: 10),
                        Text(
                          'Action Time:   ${tender.currentTime}',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 18.0,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            FlatButton(  //Scan Once
                              padding: EdgeInsets.all(20.0),
                              color: Colors.red[100],
                              onPressed: () async{
                                await DatabaseService(uid: cUser.uid, data: tender.tenderNumber).updateLogFile(
                                    tender.tenderNumber,
                                    tender.tenderName,
                                    cUser.userSection,
                                    tender.tenderSection,
                                    tender.tenderOwnerName,
                                    'inward',
                                    cUser.userName,
                                    dateFormat.format(DateTime.now()),
                                    'Finished');
                                await DatabaseService(data: tender.tenderNumber).deleteTenderData(tender.tenderNumber);
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Finish",
                                style:
                                TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                              ),
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.blue, width: 3.0),
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                          ],
                        ),

                      ],
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
