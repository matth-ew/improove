import 'package:flutter/material.dart';
import 'package:improove/widgets/pricing_and_plans/widgets.dart';

class SubPlanBox extends StatelessWidget {
  final String plan;
  final String price;
  final String? discount;
  final String weekly;
  final int id;
  final int? selectedPlan;
  final Function(int)? callback;

  const SubPlanBox(
      {Key? key,
      required this.plan,
      required this.price,
      this.discount,
      required this.weekly,
      required this.id,
      required this.selectedPlan,
      required this.callback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.04),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          highlightColor: Colors.white,
          onTap: () => {callback!(id)},
          child: Container(
            clipBehavior: Clip.hardEdge,
            height: MediaQuery.of(context).size.width * 0.35,
            width: MediaQuery.of(context).size.width * 0.25,
            decoration: BoxDecoration(
              border: Border.all(
                  color: selectedPlan == id
                      ? Colors.blue[300]!
                      : Colors.grey[300]!,
                  width: selectedPlan == id ? 3.0 : 1.0),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.only(top: 12, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SubBuildPlanLabel(label: plan),
                Visibility(
                  visible: discount != null,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SubBuildDiscountLabel(label: discount ?? ""),
                  ),
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: SubBuildPlanPrice(price: price),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: SubBuildWeeklyLabel(label: weekly),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
