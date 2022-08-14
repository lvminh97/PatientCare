// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:patient_care/config.dart';
import 'package:patient_care/widget/ControlButton.dart';
import 'package:patient_care/widget/Header.dart';
import 'package:patient_care/widget/MyDrawer.dart';

class ControlPage extends StatelessWidget {

  late BuildContext _context;

  ControlPage({Key? key}) : super(key: key);

  void _initParams(){
    Config.refs['RELAY1']!.onValue.listen((event) {
      Config.params['RELAY1'] = int.parse(event.snapshot.value.toString());
      (_context as Element).markNeedsBuild();
    });
    Config.refs['RELAY2']!.onValue.listen((event) {
      Config.params['RELAY2'] = int.parse(event.snapshot.value.toString());
      (_context as Element).markNeedsBuild();
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    _initParams();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: [
              MyHeader("Điều khiển"),
              Container(
                margin: const EdgeInsets.only(
                  top: 50
                )
              ),
              ControlButton("RELAY1", "Đèn 1", const [20, 15]),
              ControlButton("RELAY2", "Đèn 2", const [20, 15])
            ],
          ),
        ),
        drawer: MyDrawer(DrawerSelection.control),
      ),
    );
  }
}