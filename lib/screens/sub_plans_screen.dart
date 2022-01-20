import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:improove/widgets/pricing_and_plans/widgets.dart';

class Sub_plans_screen extends StatefulWidget {
  const Sub_plans_screen({Key? key}) : super(key: key);

  @override
  _Sub_plans_screen createState() => _Sub_plans_screen();
}

class _Sub_plans_screen extends State<Sub_plans_screen> {
  int selectedPlan = 0;

  set integer(int value) => setState(() => selectedPlan = value);

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff4f4f4),
      appBar: AppBar(
        centerTitle: false,
        leading: Icon(
          CupertinoIcons.back,
          color: Colors.black,
        ),
        title: Text(
          'Subscriptions',
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
        elevation: 0,
        backgroundColor: Color(0xfff4f4f4),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            sub_logo(),
            sub_improove(),
            sub_currentPlan(selectedPlan: selectedPlan),
            // sub_infoBox(),
            sub_details(),
            Expanded(
                child: sub_planLayout(
                    callback: (val) => setState(() => selectedPlan = val),
                    selectedPlan: selectedPlan)),
          ],
        ),
      ),
    );
  }
}
