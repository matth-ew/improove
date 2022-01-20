import 'package:flutter/material.dart';

class sub_buildPlanPrice extends StatefulWidget {
  final String price;

  const sub_buildPlanPrice({Key? key, required this.price}) : super(key: key);

  @override
  _sub_buildPlanPrice createState() => _sub_buildPlanPrice();
}

class _sub_buildPlanPrice extends State<sub_buildPlanPrice> {
  Widget build(BuildContext context) {
    return Text(
      widget.price,
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.w900, fontSize: 14),
      textAlign: TextAlign.center,
    );
  }
}
