import 'package:flutter/cupertino.dart';
import 'package:patient_care/screen/ChartPage.dart';
import 'package:patient_care/screen/ControlPage.dart';
import 'package:patient_care/screen/HomePage.dart';
import 'package:patient_care/screen/LoginPage.dart';

class MyRoute {
  static final Map<String, WidgetBuilder> _routes = {
    '/login': (context) => LoginPage(),
    '/home': (context) => HomePage(),
    '/control': (context) => ControlPage(),
    '/chart/heart': (context) => ChartPage("heart"),
    '/chart/spo2':(context) => ChartPage("spo2")
  };

  static Map<String, WidgetBuilder> getRoutes(){
    return _routes;
  }
}