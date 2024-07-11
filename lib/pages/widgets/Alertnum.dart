import 'package:flutter/material.dart';

class Alertnum extends StatelessWidget {
  final int? num;
  const Alertnum({Key? key, this.num = 0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return num != 0
        ? Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: const Color(0xffff4454),
                borderRadius: BorderRadius.circular(10)),
            child: Text(
              num.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ))
        : Container();
  }
}
