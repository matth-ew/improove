import 'package:flutter/material.dart';
import 'package:improove/widgets/pricing_and_plans/widgets.dart';

class sub_buildPlanLabel extends StatefulWidget {
  final String label;

  const sub_buildPlanLabel({Key? key, required this.label}) : super(key: key);

  @override
  _sub_buildPlanLabel createState() => _sub_buildPlanLabel();
}

class _sub_buildPlanLabel extends State<sub_buildPlanLabel> {
  Widget build(BuildContext context) {
    return Text(
      widget.label,
      style: TextStyle(
          letterSpacing: 0.1,
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 12),
      textAlign: TextAlign.center,
    );
  }
}
