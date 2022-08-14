// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'dart:collection';
import 'package:patient_care/model/DataPoint.dart';

enum ScreenSelection {login, param, control}

class Config{
  static String uid = "";
  static String email = "";
  static ScreenSelection screen = ScreenSelection.login;
  static HashMap<String, DatabaseReference> refs = HashMap<String, DatabaseReference>();
  static List<String> paramName = ["Heart", "SpO2", "Air_Temp", "Air_Humi", "Body_Temp", "SOS", "RELAY1", "RELAY2"];
  static HashMap<String, int> params = HashMap<String, int>();
  static List<DataPoint> heart_series = [], spo2_series = [];
  static int heart_series_cnt = 150, spo2_series_cnt = 150;

  static void paramInit() async{
    for(int i = 0; i < paramName.length; i++){
      refs[paramName[i]] = FirebaseDatabase.instance.ref("$uid/${paramName[i]}");
      params[paramName[i]] = 0;
    }

    for(int i = 0; i < 100; i++){
      heart_series.add(DataPoint(i, 0));
      spo2_series.add(DataPoint(i, 0));
    }
    Timer.periodic(
      const Duration(seconds: 1), 
      (timer) { 
        heart_series.removeAt(0);
        heart_series.add(DataPoint(heart_series_cnt, params['Heart']!));
        heart_series_cnt++;
        spo2_series.removeAt(0);
        spo2_series.add(DataPoint(spo2_series_cnt, params['SpO2']!));
        spo2_series_cnt++;
      }
    );
  }
}