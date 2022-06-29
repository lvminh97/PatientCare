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
    Config.refs['Air_Temp']!.onValue.listen((event) {
      setState(() {
        Config.params['Air_Temp'] = int.parse(event.snapshot.value.toString());
      });
    });
    Config.refs['Air_Humi']!.onValue.listen((event) {
      setState(() {
        Config.params['Air_Humi'] = int.parse(event.snapshot.value.toString());
      });
    });
    Config.refs['Body_Temp']!.onValue.listen((event) {
      setState(() {
        Config.params['Body_Temp'] = int.parse(event.snapshot.value.toString());
      });
    });
    Config.refs['SOS']!.onValue.listen((event) {
      setState(() {
        Config.params['SOS'] = int.parse(event.snapshot.value.toString());
      });
    });
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
        body: Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 50
                )
              ),
              // Air temperature and humidity
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(20, 20, 15, 20),
                          child: const Image(
                            image: AssetImage("assets/images/temp.png"),
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
                                  "Nhiệt độ",
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
                                  "${Config.params['Air_Temp']}°C",
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
                            image: AssetImage("assets/images/humi.png"),
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
                                  "Độ ẩm",
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
                                  "${Config.params['Air_Humi']}%",
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
              ),
              // Heart rate and SpO2
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(20, 10, 15, 20),
                          child: const Image(
                            image: AssetImage("assets/images/heart_rate.png"),
                            width: 70,
                            height: 90,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 20, 20),
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
                          margin: const EdgeInsets.fromLTRB(20, 10, 15, 20),
                          child: const Image(
                            image: AssetImage("assets/images/spo2.png"),
                            width: 70,
                            height: 90,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 20, 20),
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
              ),
              // Body temperature
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 10, 15, 20),
                    child: const Image(
                      image: AssetImage("assets/images/body_temp.png"),
                      width: 70,
                      height: 90,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 20, 20),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 0
                          ),
                          child: const Text(
                            "Nhiệt độ cơ thể",
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
                            "${Config.params['Body_Temp']}°C",
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
              // SOS status
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 10, 15, 20),
                    child: const Image(
                      image: AssetImage("assets/images/sos.png"),
                      width: 70,
                      height: 90,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 20, 20),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 0
                          ),
                          child: const Text(
                            "Tình trạng khẩn cấp",
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
                            Config.params['SOS'] == 1 ? "Có" : "Không",
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
              // RELAY 1
              Container(
                margin: const EdgeInsets.fromLTRB(20, 40, 15, 20),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {},
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
                margin: const EdgeInsets.fromLTRB(20, 10, 15, 20),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {},
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
      ),
    );
  }

}