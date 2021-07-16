import 'package:flutter/material.dart';
import 'package:flutter_scanner/models/tender.dart';
import 'package:flutter_scanner/tender_tile.dart';
import 'package:provider/provider.dart';

class TenderList extends StatefulWidget {
  final String filter;

  TenderList({this.filter});

  @override
  _TenderListState createState() => _TenderListState();
}

class _TenderListState extends State<TenderList> {
  List filteredList;

  @override
  Widget build(BuildContext context) {
    final tenders = Provider.of<List<Tender>>(context);
    filteredList = tenders;
    String filter = widget.filter;

    // tenders.forEach((tender) {
    // });
    if (tenders != null) {
      if(filter != null)
      filteredList = tenders
          .where((element) => element.tenderNumber.contains(filter))
          .toList();
      return ListView.builder(
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          return TenderTile(tender: filteredList[index]);
        },
      );
    } else
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Loading...',
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 50),
          ),
        ],
      );
  }
}
