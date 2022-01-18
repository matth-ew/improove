import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/actions/improove_purchases.dart';
import 'package:improove/redux/models/models.dart';
import 'package:redux/redux.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var upgrades = context.watch<DashPurchases>();
    return StoreConnector(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {
        var storeState = StoreState.available;

        Widget storeWidget;
        switch (storeState) {
          case StoreState.loading:
            storeWidget = _PurchasesLoading();
            break;
          case StoreState.available:
            storeWidget = _PurchaseList(
                improovePurchases: vm.improovePurchases,
                buy: vm.buyImprooveSubscription);
            break;
          case StoreState.notAvailable:
            storeWidget = _PurchasesNotAvailable();
            break;
        }
        return Scaffold(
          appBar: AppBar(title: Text("Payments Page Screen")),
          body: ListView(children: [
            storeWidget,
            const Padding(
              padding: EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 0.0),
              child: Text(
                'Past purchases',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            // const PastPurchasesWidget(),
          ]),
        );
      },
    );
  }
}

class _PurchasesLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Store is loading'));
  }
}

class _PurchasesNotAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Store not available'));
  }
}

class _PurchaseList extends StatelessWidget {
  final ImproovePurchases? improovePurchases;
  final Function buy;
  const _PurchaseList({Key? key, this.improovePurchases, required this.buy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var purchases = context.watch<DashPurchases>();
    var products = improovePurchases?.products;
    if (products != null && products.isNotEmpty) {
      return Column(
        children: products
            .map((product) => _PurchaseWidget(
                product: product,
                onPressed: () {
                  buy(product);
                  // improovePurchases?.buy(product);
                }))
            .toList(),
      );
    } else
      return const SizedBox.shrink();
  }
}

class _PurchaseWidget extends StatelessWidget {
  final PurchasableProduct product;
  final VoidCallback onPressed;

  const _PurchaseWidget({
    Key? key,
    required this.product,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var title = product.title;
    if (product.status == ProductStatus.purchased) {
      title += ' (purchased)';
    }
    return InkWell(
        onTap: onPressed,
        child: ListTile(
          title: Text(
            title,
          ),
          subtitle: Text(product.description),
          trailing: Text(_trailing()),
        ));
  }

  String _trailing() {
    switch (product.status) {
      case ProductStatus.purchasable:
        return product.price;
      case ProductStatus.purchased:
        return 'purchased';
      case ProductStatus.pending:
        return 'buying...';
    }
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


// class PastPurchasesWidget extends StatelessWidget {
//   const PastPurchasesWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var purchases = context.watch<IAPRepo>().purchases;
//     return ListView.separated(
//       shrinkWrap: true,
//       itemCount: purchases.length,
//       itemBuilder: (context, index) => ListTile(
//         title: Text(purchases[index].title),
//         subtitle: Text(purchases[index].status.toString()),
//       ),
//       separatorBuilder: (context, index) => const Divider(),
//     );
//   }
// }
