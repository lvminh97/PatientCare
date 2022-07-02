import 'package:flutter/material.dart';
import 'package:patient_care/config.dart';
import 'package:patient_care/widget/Header.dart';
import 'package:patient_care/widget/MyDrawer.dart';
import 'package:patient_care/widget/ParamView.dart';

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
              MyHeader("Giám sát"),
              // Air temperature and humidity
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: ParamView(
                      "assets/images/temp.png",
                      "Air_Temp",
                      "°C",
                      "Nhiệt độ",
                      const [20, 10, 15, 20]
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: ParamView(
                      "assets/images/humi.png",
                      "Air_Humi",
                      "%",
                      "Độ ẩm",
                      const [20, 10, 15, 20]
                    ),
                  )
                ],
              ),
              // Heart rate and SpO2
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: ParamView(
                      "assets/images/heart_rate.png",
                      "Heart",
                      "",
                      "Nhịp tim",
                      const [20, 10, 15, 20]
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: ParamView(
                      "assets/images/spo2.png",
                      "SpO2",
                      "%",
                      "SpO2",
                      const [20, 10, 15, 20]
                    )
                  )
                ],
              ),
              // Body temperature
              ParamView(
                "assets/images/body_temp.png",
                "Body_Temp",
                "°C",
                "Nhiệt độ cơ thể",
                const [20, 10, 15, 20]
              ),
              // SOS status
              ParamView(
                "assets/images/sos.png",
                "SOS",
                "",
                "Tình trạng khẩn cấp",
                const [20, 10, 15, 20],
                type: "string",
                altValue: const ["Không", "Có"],
              )
            ],
          ),
        ),
        drawer: MyDrawer(DrawerSelection.param),
      ),
    );
  }
}