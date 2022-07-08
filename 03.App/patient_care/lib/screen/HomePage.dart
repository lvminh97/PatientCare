// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:patient_care/config.dart';
import 'package:patient_care/widget/Header.dart';
import 'package:patient_care/widget/MyDrawer.dart';
import 'package:patient_care/widget/ParamView.dart';

class HomePage extends StatelessWidget {

  late BuildContext _context;

  HomePage({Key? key}) : super(key: key);

  void _initParams(){
    Config.refs['Heart']!.onValue.listen((event) {
      Config.params['Heart'] = int.parse(event.snapshot.value.toString());
      (_context as Element).markNeedsBuild();
    });
    Config.refs['SpO2']!.onValue.listen((event) {
      Config.params['SpO2'] = int.parse(event.snapshot.value.toString());
      (_context as Element).markNeedsBuild();
    });
    Config.refs['Air_Temp']!.onValue.listen((event) {
      Config.params['Air_Temp'] = int.parse(event.snapshot.value.toString());
      (_context as Element).markNeedsBuild();
    });
    Config.refs['Air_Humi']!.onValue.listen((event) {
      Config.params['Air_Humi'] = int.parse(event.snapshot.value.toString());
      (_context as Element).markNeedsBuild();
    });
    Config.refs['Body_Temp']!.onValue.listen((event) {
      Config.params['Body_Temp'] = int.parse(event.snapshot.value.toString());
      (_context as Element).markNeedsBuild();
    });
    Config.refs['SOS']!.onValue.listen((event) {
      Config.params['SOS'] = int.parse(event.snapshot.value.toString());
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