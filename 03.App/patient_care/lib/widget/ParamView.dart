import 'package:flutter/cupertino.dart';
import 'package:patient_care/config.dart';

// ignore: must_be_immutable
class ParamView extends StatelessWidget{

  String _img = "";
  String _paramName = "";
  String _unit = "";
  String _title = "";
  List<double> _margins = [0, 0, 0, 0];

  ParamView(String img, 
  String paramName,
  String unit,
  String title,
  List<double> margins, 
  {Key? key}): super(key: key) {
    _img = img;
    _paramName = paramName;
    _unit = unit;
    _title = title;
    _margins = margins;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(_margins[0], _margins[1], _margins[2], _margins[3]),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: Image(
              image: AssetImage(_img),
              width: 70,
              height: 90,
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 0
                  ),
                  child: Text(
                    _title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 10
                  ),
                  child: Text(
                    "${Config.params[_paramName]}$_unit",
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}