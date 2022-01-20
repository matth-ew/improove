import 'package:flutter/material.dart';
import 'package:improove/widgets/pricing_and_plans/sub_otherPlansLabel.dart';
import 'package:improove/widgets/pricing_and_plans/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class sub_planLayout extends StatelessWidget {
  final Function(int)? callback;
  final int? selectedPlan;

  sub_planLayout({this.callback, this.selectedPlan});

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: MediaQuery.of(context).size.width * 0.1,
        left: MediaQuery.of(context).size.width * 0.1,
        bottom: MediaQuery.of(context).size.width * 0.1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          sub_planRow(callback: callback, selectedPlan: selectedPlan),
          ElevatedButton(
            onPressed: () {
              // TO DO
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: const StadiumBorder(),
            ),
            child: Text(
              AppLocalizations.of(context)!.sub_upgradePlan,
              // style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
