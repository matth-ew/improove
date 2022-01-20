import 'package:flutter/material.dart';

class sub_buildDiscountLabel extends StatefulWidget {
  final String label;

  const sub_buildDiscountLabel({Key? key, required this.label})
      : super(key: key);

  @override
  _sub_buildDiscountLabel createState() => _sub_buildDiscountLabel();
}

class _sub_buildDiscountLabel extends State<sub_buildDiscountLabel> {
  Widget build(BuildContext context) {
    return Text(
      widget.label,
      style: TextStyle(
          letterSpacing: 0.2,
          color: Colors.black,
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.lineThrough,
          fontSize: 12),
      textAlign: TextAlign.start,
    );
  }
}
