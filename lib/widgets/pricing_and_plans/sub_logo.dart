import 'package:flutter/material.dart';

class SubLogo extends StatelessWidget {
  const SubLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.12),
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.width * 0.2,
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.black54.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 1))
          ]),
      child: Center(child: Image.asset('assets/images/logo.png')),
    );
  }
}