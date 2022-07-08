import 'package:firebase_database/firebase_database.dart';
import 'dart:collection';

enum ScreenSelection {login, param, control}

class Config{
  static String uid = "";
  static String email = "";
  static ScreenSelection screen = ScreenSelection.login;
  static HashMap<String, DatabaseReference> refs = HashMap<String, DatabaseReference>();
  static List<String> paramName = ["Heart", "SpO2", "Air_Temp", "Air_Humi", "Body_Temp", "SOS", "RELAY1", "RELAY2"];
  static HashMap<String, int> params = HashMap<String, int>();

  static void paramInit() async{
    for(int i = 0; i < paramName.length; i++){
      refs[paramName[i]] = FirebaseDatabase.instance.ref("$uid/${paramName[i]}");
      params[paramName[i]] = 0;
    }
  }
}