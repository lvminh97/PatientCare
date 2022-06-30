import 'package:flutter/material.dart';
import 'package:patient_care/config.dart';

// ignore: must_be_immutable
class ControlButton extends StatelessWidget {

  String _paramName = "";
  String _title = "";
  List<double> _margins = <double>[0, 0];

  ControlButton(String paramName, String title, List<double> margins, {Key? key}) : super(key: key) {
    _paramName = paramName;
    _title = title;
    _margins = margins;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(40, _margins[0], 15, _margins[1]),
      child: Row(
        children: [
          TextButton(
            onPressed: () async {
              if(Config.params[_paramName] == 1) {
                await Config.refs[_paramName]!.set(0);
              } else {
                await Config.refs[_paramName]!.set(1);
              }
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              backgroundColor: Config.params[_paramName] == 1 
                              ? MaterialStateProperty.all<Color>(Colors.blue)
                              : MaterialStateProperty.all<Color>(Colors.red)
            ), 
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
              child: Text(
                _title
              ),
            )
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 40
            ),
            child: Text(
              Config.params[_paramName] == 1 ? "Bật" : "Tắt",
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800
              )
            )
          )
        ],
      ),
    );
  }

}