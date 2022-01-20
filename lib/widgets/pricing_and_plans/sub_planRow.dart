import 'package:flutter/material.dart';
import 'package:improove/widgets/pricing_and_plans/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class sub_planRow extends StatelessWidget {
  final Function(int)? callback;
  final int? selectedPlan;

  sub_planRow({this.callback, this.selectedPlan});

  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          sub_planBox(
              plan: AppLocalizations.of(context)!.sub_one,
              price: AppLocalizations.of(context)!.sub_one_price,
              discount: AppLocalizations.of(context)!.sub_one_discount,
              weekly: AppLocalizations.of(context)!.sub_one_weekly,
              id: 0,
              selectedPlan: selectedPlan,
              callback: callback),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
          sub_planBox(
              plan: AppLocalizations.of(context)!.sub_three,
              price: AppLocalizations.of(context)!.sub_three_price,
              discount: AppLocalizations.of(context)!.sub_three_discount,
              weekly: AppLocalizations.of(context)!.sub_three_weekly,
              id: 1,
              selectedPlan: selectedPlan,
              callback: callback),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
          sub_planBox(
              plan: AppLocalizations.of(context)!.sub_six,
              price: AppLocalizations.of(context)!.sub_six_price,
              discount: AppLocalizations.of(context)!.sub_six_discount,
              weekly: AppLocalizations.of(context)!.sub_six_weekly,
              id: 2,
              selectedPlan: selectedPlan,
              callback: callback),
        ],
      ),
    );
  }
}
