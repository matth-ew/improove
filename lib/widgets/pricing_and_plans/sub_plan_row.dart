import 'package:flutter/material.dart';
import 'package:improove/redux/models/improove_purchases.dart';
import 'package:improove/widgets/pricing_and_plans/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubPlanRow extends StatelessWidget {
  final Function(int)? callback;
  final int? selectedPlan;
  final List<PurchasableProduct> products;

  const SubPlanRow({
    Key? key,
    this.callback,
    this.selectedPlan,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    const discounts = [5.49, 14.49, 39.99];
    const weeks = [4, 12, 52];
    return SizedBox(
      width: width * 0.9,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ...products.asMap().entries.map((e) {
            var id = e.key;
            var p = e.value;
            var rawPrice = p.productDetails.rawPrice;
            var currency = p.productDetails.currencySymbol;
            // var discount = ;
            return Padding(
              padding: EdgeInsets.only(
                left: id != 0 ? width * 0.01 : 0,
                right: id != products.length - 1 ? width * 0.01 : 0,
              ),
              child: SubPlanBox(
                  plan:
                      p.productDetails.title.split("-")[1].split("(")[0].trim(),
                  price: "${discounts[id]} $currency",
                  discount: p.price,
                  weekly:
                      "${(rawPrice / weeks[id]).toStringAsFixed(2)}$currency${AppLocalizations.of(context)!.sub_weekly}",
                  id: id,
                  selectedPlan: selectedPlan,
                  callback: callback),
            );
          }),
        ],
      ),
    );
  }
}