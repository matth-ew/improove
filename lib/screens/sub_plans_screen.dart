import 'package:flutter/material.dart';
import 'package:improove/utility/analytics.dart';
import 'package:improove/widgets/pricing_and_plans/sub_subtext.dart';
import 'package:improove/widgets/pricing_and_plans/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/actions/improove_purchases.dart';
import 'package:improove/redux/models/models.dart';
import 'package:redux/redux.dart';

class SubPlansScreen extends StatefulWidget {
  const SubPlansScreen({Key? key}) : super(key: key);

  @override
  _SubPlansScreen createState() => _SubPlansScreen();
}

class _SubPlansScreen extends State<SubPlansScreen> {
  int selectedPlan = 0;

  set integer(int value) => setState(() => selectedPlan = value);

  @override
  Widget build(BuildContext context) {
    // final buttonTheme = Theme.of(context).buttonTheme;
    return StoreConnector(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      onInit: (Store<AppState> store) {
        faCustomEvent(
          "SUB_SCREEN",
          {
            "user": store.state.user.id,
          },
        );
      },
      builder: (BuildContext context, _ViewModel vm) {
        return Scaffold(
          backgroundColor: const Color(0xfff4f4f4),
          appBar: AppBar(
            centerTitle: false,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text(
              'Subscriptions',
              style: TextStyle(color: Colors.black),
            ),
            elevation: 0,
            backgroundColor: const Color(0xfff4f4f4),
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              shrinkWrap: true,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.01),
                    child: Column(
                      children: <Widget>[
                        const SubLogo(),
                        const SubImproove(),
                        //SubCurrentPlan(
                        //    product:
                        //        vm.improovePurchases.products[selectedPlan],
                        //    selectedPlan: selectedPlan),
                        // sub_infoBox(),
                        SubDetails(
                          product: vm.improovePurchases.products[selectedPlan],
                        ),
                        const SubSubtext(),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                SubPlanLayout(
                  callback: (val) => setState(() => selectedPlan = val),
                  selectedPlan: selectedPlan,
                  products: vm.improovePurchases.products,
                  buy: () => vm.buyImprooveSubscription(
                      vm.improovePurchases.products[selectedPlan]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel {
  final ImproovePurchases improovePurchases;
  final Function(PurchasableProduct product, [Function? cb])
      buyImprooveSubscription;
  // final Function(String accessToken, [Function? cb]) googleLogin;
  // final Function(String accessToken, [Function? cb]) appleLogin;

  _ViewModel({
    required this.improovePurchases,
    required this.buyImprooveSubscription,
    // required this.facebookLogin,
    // required this.appleLogin,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      improovePurchases: store.state.improovePurchases,
      buyImprooveSubscription: (product, [cb]) =>
          store.dispatch(buyImprooveSubscriptionThunk(product, cb)),
      // facebookLogin: (token, [cb]) =>
      //     store.dispatch(loginFacebookThunk(token, cb)),
      // googleLogin: (token, [cb]) => store.dispatch(loginGoogleThunk(token, cb)),
      // appleLogin: (token, [cb]) => store.dispatch(loginAppleThunk(token, cb)),
    );
  }
}
