// ignore_for_file: file_names, must_be_immutable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:patient_care/config.dart';
import 'package:patient_care/model/DataPoint.dart';
import 'package:patient_care/widget/Header.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartPage extends StatelessWidget {

  late BuildContext _context;
  String _type = "heart";

  ChartPage(String type, {Key? key}) : super(key: key){
    _type = type;
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      (context as Element).markNeedsBuild();
    });
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(_context, "/home");
        return false;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: <Widget>[
              MyHeader("Giám sát"),
              Container(
                margin: const EdgeInsets.only(top: 25),
                child: Text(
                  _type == "heart" ? "Biểu đồ nhịp tim" : "Biểu đồ SpO2",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    isVisible: false
                  ),
                  primaryYAxis: NumericAxis(
                    minimum: 0,
                    maximum: _type == "heart" ? 250 : 100,
                  ),
                  series: [
                    LineSeries<DataPoint, int>(
                      dataSource: _type == "heart" ? Config.heart_series : Config.spo2_series,
                      xValueMapper: (DataPoint d, _) => d.timestamp,
                      yValueMapper: (DataPoint d, _) => d.value,
                      color: Colors.red
                    )
                  ]
                ),
              ) 
            ]
          ),
        ),
      )
    );
  }
}