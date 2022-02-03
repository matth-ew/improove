import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:improove/redux/models/improove_purchases.dart';

class SubCurrentPlan extends StatelessWidget {
  final int selectedPlan;
  final PurchasableProduct product;

  const SubCurrentPlan({
    Key? key,
    required this.selectedPlan,
    required this.product,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // const discounts = [5.49, 14.49, 39.99];
    return Center(
      child: Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "${product.productDetails.title.split("-")[1].split("(")[0].trim()} - ${product.price}",
              // (selectedPlan == 0
              //         ? AppLocalizations.of(context)!.sub_one
              //         : (selectedPlan == 1
              //             ? AppLocalizations.of(context)!.sub_three
              //             : AppLocalizations.of(context)!.sub_six)) +
              //     " - ",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
