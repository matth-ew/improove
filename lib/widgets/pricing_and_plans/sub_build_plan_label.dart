import 'package:flutter/material.dart';

class SubBuildPlanLabel extends StatelessWidget {
  final String label;
  const SubBuildPlanLabel({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
          letterSpacing: 0.1,
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 13),
      textAlign: TextAlign.center,
    );
  }
}
