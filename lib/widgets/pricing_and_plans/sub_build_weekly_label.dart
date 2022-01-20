import 'package:flutter/material.dart';

class SubBuildWeeklyLabel extends StatelessWidget {
  final String label;

  const SubBuildWeeklyLabel({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: const TextStyle(
        letterSpacing: 0.2,
        color: Colors.grey,
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
    );
  }
}
