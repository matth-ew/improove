import 'package:flutter/material.dart';

class SubBuildDiscountLabel extends StatefulWidget {
  final String label;

  const SubBuildDiscountLabel({Key? key, required this.label})
      : super(key: key);

  @override
  _SubBuildDiscountLabel createState() => _SubBuildDiscountLabel();
}

class _SubBuildDiscountLabel extends State<SubBuildDiscountLabel> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.label,
      style: const TextStyle(
          letterSpacing: 0.2,
          color: Colors.black,
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.lineThrough,
          fontSize: 12),
      textAlign: TextAlign.start,
    );
  }
}
