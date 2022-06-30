import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyHeader extends StatelessWidget {

  String _title = "";

  MyHeader(String title, {Key? key}) : super(key: key){
    _title = title;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
        bottom: 10
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage("assets/images/medical.png"),
                width: 100,
                height: 100,
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 25
                ),
                child: Text(
                  _title,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: Colors.blue
                  ),
                ),
              )
            ],
          ),
          Row(
            children: const [
              Expanded(
                child: Divider()
              )
            ],
          )
        ],
      )
    );
  }

}