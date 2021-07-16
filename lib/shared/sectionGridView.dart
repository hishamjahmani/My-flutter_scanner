import 'package:flutter/material.dart';
import 'package:flutter_scanner/models/tender.dart';
import 'package:flutter_scanner/screens/tendersDetails.dart';
import 'package:provider/provider.dart';
import "dart:collection";

class SectionsGridView extends StatelessWidget {
  const SectionsGridView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Tender> tenders = Provider.of<List<Tender>>(context);

    List<String> sections = [];
    if (tenders != null) {
      for (var i = 0; i < tenders.length; i++) {
        sections.add(tenders[i].tenderLocation);
      }
      sections = LinkedHashSet<String>.from(sections)
          .toList(); //find sections for the entered sections.
    }
    return sections != null
        ? GridView.builder(
            primary: false,
            padding: const EdgeInsets.all(17),
            scrollDirection: Axis.horizontal,
            itemCount: sections.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              // (MediaQuery.of(context).size.width-5)/60,
              //crossAxisCount: 2,
            ),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () async{
                print(sections[index]);
                await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SectionTendersDetails(sectionName: sections[index],tenders: tenders,)));},
              child: Container(
                //margin: EdgeInsets.all(5),
                // height: 150,
                // width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                      image:
                          AssetImage('assets/images/${sections[index]}.jpg'),),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset.fromDirection(3.14 / 4, 10),
                      blurRadius: 10,
                      spreadRadius: 0,
                      color: Colors.grey[700],
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Container(
                      height: 20,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(7),
                        ),
                        color: tenders
                                    .where((val) =>
                                        val.tenderDirection.contains('outward'))
                                    .where((val) => val.tenderLocation
                                        .contains(sections[index]))
                                    .length !=
                                0
                            ? Colors.red[400]
                            : Colors.green[300],
                      ),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            '${tenders.where((val) => val.tenderLocation.contains(sections[index])).where((element) => element.tenderDirection.contains('outward')).length.toString()} / ${tenders.where((val) => val.tenderLocation.contains(sections[index])).length.toString()}'),
                        SizedBox(
                          width: 5,
                        ),
                        //Text(sections[index].substring(0, 3)),
                      ],
                    ),
                    ),
                    
                  ],
                ),
                //onTap: ,
              ),
            ),
          )
        : Image(image: AssetImage('assets/logo.jpg'));
  }
}
