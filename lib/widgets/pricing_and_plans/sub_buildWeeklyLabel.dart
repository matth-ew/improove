import 'package:flutter/material.dart';

class sub_buildWeeklyLabel extends StatefulWidget {
  final String label;

  const sub_buildWeeklyLabel({Key? key, required this.label}) : super(key: key);

  @override
  _sub_buildWeeklyLabel createState() => _sub_buildWeeklyLabel();
}

class _sub_buildWeeklyLabel extends State<sub_buildWeeklyLabel> {
  Widget build(BuildContext context) {
    return Text(
      widget.label,
      textAlign: TextAlign.center,
      style: TextStyle(
        letterSpacing: 0.2,
        color: Colors.grey,
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
    );
  }
}
