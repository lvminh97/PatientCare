import 'package:flutter/material.dart';
import 'package:patient_care/config.dart';

class HomePage extends StatefulWidget {
  
  const HomePage({Key? key}): super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  @override
  void initState(){
    super.initState();
    _initParams();
  }

  void _initParams(){
    Config.refs['Heart']!.onValue.listen((event) {
      setState(() {
        Config.params['Heart'] = int.parse(event.snapshot.value.toString());
      });
    });
    Config.refs['SpO2']!.onValue.listen((event) {
      setState(() {
        Config.params['SpO2'] = int.parse(event.snapshot.value.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 50
                )
              ),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(20, 20, 15, 20),
                          child: const Image(
                            image: AssetImage("assets/images/heart_rate.png"),
                            width: 70,
                            height: 90,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 20, 20, 20),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 0
                                ),
                                child: const Text(
                                  "Nhịp tim",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  ),
                                )
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 10
                                ),
                                child: Text(
                                  Config.params['Heart'] .toString(),
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(20, 20, 15, 20),
                          child: const Image(
                            image: AssetImage("assets/images/spo2.png"),
                            width: 70,
                            height: 90,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 20, 20, 20),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 0
                                ),
                                child: const Text(
                                  "SpO2",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  ),
                                )
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 10
                                ),
                                child: Text(
                                  "${Config.params['SpO2']}%",
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}