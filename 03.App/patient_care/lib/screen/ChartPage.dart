// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
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
                  primaryXAxis: CategoryAxis(),
                  series: <LineSeries<Data, String>>[
                    LineSeries<Data, String>(
                      dataSource: <Data>[
                        Data('Tom', 10),
                        Data('Jane', 7),
                        Data('Thor', 20),
                        Data('Bill', 13)
                      ],
                      xValueMapper: (Data d, _) => d.name,
                      yValueMapper: (Data d, _) => d.value
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

class Data{
  String name = "";
  int value = 0;

  Data(String _name, int _value){
    name = _name;
    value = _value;
  }
}