import 'package:flutter/material.dart';

class SubBuildPlanPrice extends StatelessWidget {
  final String price;

  const SubBuildPlanPrice({Key? key, required this.price}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      price,
      style: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.w900, fontSize: 14),
      textAlign: TextAlign.center,
    );
  }
}
