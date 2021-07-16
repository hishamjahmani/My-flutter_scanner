import 'package:flutter/material.dart';


const textInputDecoration = InputDecoration(
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
  borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width: 2.0),
  ),
);

var sendButtonColor = Colors.red.shade100;
var receiveButtonColor = Colors.green.shade100;

List<String> sectionsList = <String> ['Mechanical', 'Electronics', 'Medicine', 'Equipment', 'Stationary', 'CTC',
'Auditing', 'Bureau', 'GM', 'Accounting'];
