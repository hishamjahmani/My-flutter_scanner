import 'package:flutter/material.dart';
import 'package:flutter_scanner/models/tender.dart';
import 'package:flutter_scanner/shared/constants.dart';

class SectionTendersDetails extends StatefulWidget {
  const SectionTendersDetails({Key key, this.sectionName, this.tenders})
      : super(key: key);
  final String sectionName;
  final List<Tender> tenders;

  @override
  _SectionTendersDetailsState createState() => _SectionTendersDetailsState();
}

class _SectionTendersDetailsState extends State<SectionTendersDetails> {
  String certainTender;

  @override
  void initState() {
    super.initState();
    certainTender = '';
  }

  final TextEditingController searchTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    String filter = widget.sectionName;
    List<Tender> tenders;

    if (certainTender == '') {
      tenders = widget.tenders
          .where((element) => element.tenderSection.contains(filter))
          .toList();
    } else {
      tenders = widget.tenders
          .where((element) => element.tenderNumber.contains(certainTender))
          .where((element) => element.tenderSection.contains(filter))
          .toList();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Tenders of $filter'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
              DataTable(
                //columnSpacing: 25,
                columns: <DataColumn>[
                  DataColumn(
                    label: Flexible(
                      flex: 1,
                      child: Text(
                        'Tender No.',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Flexible(
                      flex: 1,
                      child: Text(
                        'Location',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Flexible(
                      flex: 1,
                      child: Text(
                        'Time',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ],
                rows: List<DataRow>.generate(
                    tenders?.length,
                    (index) => DataRow(cells: <DataCell>[
                          DataCell(Text('${tenders[index].tenderNumber}')),
                          DataCell(Text('${tenders[index].tenderLocation}')),
                          DataCell(Text(
                            '${tenders[index].currentTime}',
                            style: TextStyle(
                                color:
                                    tenders[index].tenderDirection == 'outward'
                                        ? Colors.red[800]
                                        : Colors.green[800]),
                          )),
                        ])),
              ),
            ],
          ),
        ));
  }
}
