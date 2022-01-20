import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:improove/redux/models/improove_purchases.dart';

class SubDetails extends StatelessWidget {
  final PurchasableProduct? product;
  const SubDetails({
    Key? key,
    this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Text(
              product?.description ?? "",
              //AppLocalizations.of(context)!.sub_description,
              style: const TextStyle(
                  letterSpacing: 0.5,
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 18),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
