// ignore_for_file: file_names, must_be_immutable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:patient_care/widget/Header.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartPage extends StatelessWidget {

  late BuildContext _context;
  String _type = "heart";
  List<DataPoint> _data = [];

  ChartPage(String type, {Key? key}) : super(key: key){
    _type = type;
  }
  
  void generateData(){
    Random rng = Random();
    int start = 1659694531, cnt = 0;
    while(cnt < 100){
      if(_type == "heart") {
        _data.add(DataPoint(start, rng.nextInt(6) + 68));
      } else {
        _data.add(DataPoint(start, rng.nextInt(4) + 89));
      }
      start++;
      cnt++;
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    generateData();
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
                    maximum: _type == "heart" ? 120 : 100,
                  ),
                  series: [
                    LineSeries<DataPoint, int>(
                      dataSource: _data,
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

class DataPoint{
  int timestamp = 0;
  int value = 0;

  DataPoint(int _ts, int _value){
    timestamp = _ts;
    value = _value;
  }
}