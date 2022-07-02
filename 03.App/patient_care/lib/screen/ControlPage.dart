import 'package:flutter/material.dart';
import 'package:patient_care/config.dart';
import 'package:patient_care/widget/ControlButton.dart';
import 'package:patient_care/widget/Header.dart';
import 'package:patient_care/widget/MyDrawer.dart';

class ControlPage extends StatefulWidget {
  
  const ControlPage({Key? key}): super(key: key);

  @override
  State<StatefulWidget> createState() => ControlPageState();
}

class ControlPageState extends State<ControlPage> {

  @override
  void initState(){
    super.initState();
    _initParams();
  }

  void _initParams(){
    Config.refs['RELAY1']!.onValue.listen((event) {
      setState(() {
        Config.params['RELAY1'] = int.parse(event.snapshot.value.toString());
      });
    });
    Config.refs['RELAY2']!.onValue.listen((event) {
      setState(() {
        Config.params['RELAY2'] = int.parse(event.snapshot.value.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
              ControlButton("RELAY1", "Relay 1", const [20, 15]),
              ControlButton("RELAY2", "Relay 2", const [20, 15])
            ],
          ),
        ),
        drawer: MyDrawer(DrawerSelection.control),
      ),
    );
  }
}