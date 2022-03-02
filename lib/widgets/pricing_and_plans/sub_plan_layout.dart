import 'package:flutter/material.dart';
import 'package:improove/redux/models/improove_purchases.dart';
import 'package:improove/widgets/pricing_and_plans/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:improove/screens/webview_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
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
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(
        //right: MediaQuery.of(context).size.width * 0.1,
        //left: MediaQuery.of(context).size.width * 0.1,
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
          Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.1,
              left: MediaQuery.of(context).size.width * 0.1,
            ),
            child: ElevatedButton(
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
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * 0.02,
              right: MediaQuery.of(context).size.width * 0.1,
              left: MediaQuery.of(context).size.width * 0.1,
            ),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: textTheme.overline,
                children: [
                  TextSpan(
                    text: "${AppLocalizations.of(context)!.legalText} ",
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context)!.termsConditions,
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        pushNewScreen(
                          context,
                          screen: const WebViewScreen(
                              url: "https://improove.fit/terms"),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                  ),
                  TextSpan(
                    text: ' ${AppLocalizations.of(context)!.and} ',
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context)!.privacyPolicy,
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        pushNewScreen(
                          context,
                          screen: const WebViewScreen(
                              url: "https://improove.fit/privacy"),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
