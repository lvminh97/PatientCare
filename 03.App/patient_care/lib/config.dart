import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'dart:collection';

class Config{
  static String uid = "";
  static String email = "";
  // static List<DatabaseReference> refs = [];
  static HashMap<String, DatabaseReference> refs = HashMap<String, DatabaseReference>();
  static HashMap<String, int> params = HashMap<String, int>();

  static void paramInit() async{
    refs['Heart'] = FirebaseDatabase.instance.ref("$uid/Heart");
    refs['SpO2'] = FirebaseDatabase.instance.ref("$uid/SpO2");

    params['Heart'] = 0;
    params['SpO2'] = 0;
  }
}