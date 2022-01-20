import 'package:flutter/material.dart';
import 'package:improove/widgets/pricing_and_plans/widgets.dart';

class sub_planBox extends StatefulWidget {
  final String plan;
  final String price;
  final String discount;
  final String weekly;
  final int id;
  final int? selectedPlan;
  final Function(int)? callback;

  const sub_planBox(
      {Key? key,
      required this.plan,
      required this.price,
      required this.discount,
      required this.weekly,
      required this.id,
      required this.selectedPlan,
      required this.callback})
      : super(key: key);

  @override
  _sub_planBox createState() => _sub_planBox();
}

class _sub_planBox extends State<sub_planBox> {
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.04),
      child: Material(
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          highlightColor: Colors.white,
          onTap: () => {widget.callback!(widget.id)},
          child: Container(
            height: MediaQuery.of(context).size.width * 0.35,
            width: MediaQuery.of(context).size.width * 0.25,
            decoration: BoxDecoration(
              border: Border.all(
                  color: widget.selectedPlan == widget.id
                      ? Colors.blue[300]!
                      : Colors.grey[300]!,
                  width: widget.selectedPlan == widget.id ? 3.0 : 1.0),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.only(top: 12, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                sub_buildPlanLabel(label: widget.plan),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: sub_buildDiscountLabel(label: widget.discount),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: sub_buildPlanPrice(price: widget.price),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: sub_buildWeeklyLabel(label: widget.weekly),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
