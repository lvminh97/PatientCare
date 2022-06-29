import 'package:flutter/material.dart';
import 'package:patient_care/config.dart';
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
              Container(
                margin: const EdgeInsets.only(
                  top: 50
                )
              ),
              // RELAY 1
              Container(
                margin: const EdgeInsets.fromLTRB(40, 40, 15, 20),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        if(Config.params['RELAY1'] == 1) {
                          await Config.refs['RELAY1']!.set(0);
                        } else {
                          await Config.refs['RELAY1']!.set(1);
                        }
                      },
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                        backgroundColor: Config.params['RELAY1'] == 1 
                                        ? MaterialStateProperty.all<Color>(Colors.blue)
                                        : MaterialStateProperty.all<Color>(Colors.red)
                      ), 
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                        child: Text(
                          "Relay 1"
                        ),
                      )
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 40
                      ),
                      child: Text(
                        Config.params['RELAY1'] == 1 ? "Bật" : "Tắt",
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800
                        )
                      )
                    )
                  ],
                ),
              ),
              // RELAY 2
              Container(
                margin: const EdgeInsets.fromLTRB(40, 10, 15, 20),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        if(Config.params['RELAY2'] == 1) {
                          await Config.refs['RELAY2']!.set(0);
                        } else {
                          await Config.refs['RELAY2']!.set(1);
                        }
                      },
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                        backgroundColor: Config.params['RELAY2'] == 1 
                                        ? MaterialStateProperty.all<Color>(Colors.blue)
                                        : MaterialStateProperty.all<Color>(Colors.red)
                      ), 
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                        child: Text(
                          "Relay 2"
                        ),
                      )
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 40
                      ),
                      child: Text(
                        Config.params['RELAY2'] == 1 ? "Bật" : "Tắt",
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800
                        )
                      )
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        drawer: MyDrawer(DrawerSelection.control),
      ),
    );
  }

}