// ignore_for_file: file_names, must_be_immutable, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:patient_care/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget{

  late BuildContext _context;
  late TextEditingController _usernameTxtCtrl, _passwordTxtCtrl;

  LoginPage({Key? key}) : super(key: key);
  
  void _initLoginData() async{
    final prefs = await SharedPreferences.getInstance();
    _usernameTxtCtrl.text = prefs.getString("username")!;
    _passwordTxtCtrl.text = prefs.getString("password")!;
  }

  void _login() async{
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.dualRing;
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.dark;
    EasyLoading.show(status: "Đang đăng nhập...", maskType: EasyLoadingMaskType.black);
    FirebaseAuth auth = FirebaseAuth.instance;
    String errorStr = "";
    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: _usernameTxtCtrl.text, 
        password: _passwordTxtCtrl.text
      );
      Config.uid = userCredential.user!.uid;
      Config.email = userCredential.user!.email!;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("username", _usernameTxtCtrl.text);
      await prefs.setString("password", _passwordTxtCtrl.text);

      EasyLoading.dismiss();
      Config.paramInit();
      Navigator.pushReplacementNamed(_context, "/home");
      Config.screen = ScreenSelection.param;
    } on FirebaseAuthException catch(e){
      // print("Login error: " + e.code);
      if(e.code == "user-not-found"){
        errorStr = "Email không tồn tại!";
      }
      else if(e.code == "wrong-password"){
        errorStr = "Sai mật khẩu!";
      }
      else{
        errorStr = "Sai email hoặc mật khẩu!";
      }
      EasyLoading.dismiss();
      showDialog(
        context: _context, 
        builder: (context) {
          return AlertDialog(
            title: const Text('Đăng nhập thất bại'),
            content: Text(errorStr),
            actions: <Widget>[
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                }, 
                child: const Text('Close')
              )
            ],
          );
        }
      );
    }
  }

  @override
  Widget build(BuildContext context){
    _context = context;
    _usernameTxtCtrl = TextEditingController();
    _passwordTxtCtrl = TextEditingController();
    _initLoginData();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                child: const Image(
                  image: AssetImage('assets/images/medical.png'),
                  height: 200,
                  width: 375,
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Email',
                  ),
                  controller: _usernameTxtCtrl,
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Mật khẩu'
                  ),
                  obscureText: true,
                  controller: _passwordTxtCtrl,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextButton(
                  onPressed: _login,
                  style: ButtonStyle( 
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)
                  ), 
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                    child: Text(
                      'Đăng nhập',
                    ),
                  ),
                ),
              )
            ]
          ),
        )
      ),
    );
  }
}