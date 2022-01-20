import 'package:flutter/material.dart';
import 'package:improove/redux/models/improove_purchases.dart';
import 'package:improove/widgets/pricing_and_plans/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubPlanLayout extends StatelessWidget {
  final Function(int)? callback;
  final Function() buy;
  final List<PurchasableProduct> products;
  final int? selectedPlan;

  const SubPlanLayout({
    Key? key,
    this.callback,
    this.selectedPlan,
    required this.products,
    required this.buy,
  }) : super(key: key);

  @override
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
          SubPlanRow(
              callback: callback,
              selectedPlan: selectedPlan,
              products: products),
          ElevatedButton(
            onPressed: () {
              buy();
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
