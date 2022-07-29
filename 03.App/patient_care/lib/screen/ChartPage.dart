// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:patient_care/widget/Header.dart';

class ChartPage extends StatelessWidget {

  late BuildContext _context;
  String _type = "heart";

  ChartPage(String type, {Key? key}) : super(key: key){
    _type = type;
  }
  
  @override
  Widget build(BuildContext context) {
    _context = context;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(_context, "/home");
        return false;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: <Widget>[
              MyHeader("Giám sát"),
            ]
          ),
        ),
      )
    );
  }
}