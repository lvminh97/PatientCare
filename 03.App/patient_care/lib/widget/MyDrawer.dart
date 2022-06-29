import 'package:flutter/material.dart';
import 'package:patient_care/config.dart';
import 'package:patient_care/screen/ControlPage.dart';
import 'package:patient_care/screen/HomePage.dart';
import 'package:patient_care/screen/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum DrawerSelection {param, control}

// ignore: must_be_immutable
class MyDrawer extends StatelessWidget{

  DrawerSelection _drawerSelection = DrawerSelection.param;

  MyDrawer(DrawerSelection selection, {Key? key}) : super(key: key){
    _drawerSelection = selection;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Center(
              child: Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Icon(Icons.account_circle, color: Colors.white, size: 40)
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      Config.email,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                    ),
                  )
                ],
              ),
            )
          ),
          ListTile(
            selected: _drawerSelection == DrawerSelection.param,
            title: const Text('Dữ liệu'),
            leading: const Icon(Icons.home, size: 25),
            onTap: () {
              if(_drawerSelection != DrawerSelection.param){
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const HomePage())
                );
              }
            },
          ),
          ListTile(
            selected: _drawerSelection == DrawerSelection.control,
            title: const Text('Điều khiển'),
            leading: const Icon(Icons.settings, size: 25),
            onTap: () {
              if(_drawerSelection != DrawerSelection.control){
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const ControlPage())
                );
              }
            },
          ),
          ListTile(
            title: const Text('Đăng xuất'),
            leading: const Icon(Icons.logout, size: 25),
            onTap: () async{
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove("password");
              // ignore: use_build_context_synchronously
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const LoginPage())
              );
            },
          )
        ],
      ),
    );
  }
}