// import 'dart:io';

// import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:improove/const/text.dart';
import 'package:improove/redux/actions/user.dart';
// import 'package:improove/redux/actions/actions.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/services/payment_service.dart';
import 'package:improove/utility/device_storage.dart';
// import 'package:improove/services/user_service.dart';
// import 'package:improove/utility/device_storage.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';

class SetImproovePurchases {
  final ImproovePurchases ip;
  SetImproovePurchases(this.ip);
}

ThunkAction<AppState> validateSubscriptionThunk(PurchaseDetails purchaseDetails,
    [Function? cb]) {
  return (Store<AppState> store) async {
    try {
      final token = await getAccessToken();
      if (token != null) {
        final Response? r = await PaymentService().validateSubscriptions(
            purchaseDetails.verificationData.source,
            purchaseDetails.verificationData.serverVerificationData,
            purchaseDetails.productID,
            token);
        debugPrint("UE RESP ${r?.data}");
        if (r?.data['success'] != null && r?.data['success'] as bool) {
          store.dispatch(SetSubscribed(true));
          if (purchaseDetails.pendingCompletePurchase) {
            await store.state.improovePurchases.iapConnection
                ?.completePurchase(purchaseDetails);
            cb?.call(null);
          }
        } else {
          cb?.call(r?.data['msg'] ?? "Error");
        }
      }
    } catch (e) {
      debugPrint("UE ERR $e");
      cb?.call(e.toString());
    }
  };
}

ThunkAction<AppState> buyImprooveSubscriptionThunk(PurchasableProduct product,
    [Function? cb]) {
  return (Store<AppState> store) async {
    final _iap = store.state.improovePurchases;
    try {
      final purchaseParam =
          PurchaseParam(productDetails: product.productDetails);
      if (storeKeySubscriptions.contains(product.id)) {
        await _iap.iapConnection
            ?.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        throw ArgumentError.value(
            product.productDetails, '${product.id} is not a known product');
      }
      // switch (product.id) {
      // case storeKeyConsumable:
      //   await iapConnection.buyConsumable(purchaseParam: purchaseParam);
      //   break;
      // case storeKeySubscription:
      // case storeKeyUpgrade:
      //   await _iap.iapConnection
      //       ?.buyNonConsumable(purchaseParam: purchaseParam);
      //   break;
      // default:throw ArgumentError.value(
      //       product.productDetails, '${product.id} is not a known product');
      // }
    } catch (e) {
      debugPrint("UE ERR $e");
      cb?.call(e);
    }
  };
}

ThunkAction<AppState> initImproovePurchases([Function? cb]) {
  return (Store<AppState> store) async {
    try {
      debugPrint("UE INIT IP");
      final InAppPurchase _iap = InAppPurchase.instance;
      final available = await _iap.isAvailable();
      var _storeState = StoreState.loading;
      List<PurchasableProduct> _prod = [];
      if (!available) {
        _storeState = StoreState.notAvailable;
      } else {
        const ids = <String>{
          // storeKeyConsumable,
          ...storeKeySubscriptions,
          // storeKeyUpgrade,
        };
        final response = await _iap.queryProductDetails(ids);
        for (var element in response.notFoundIDs) {
          debugPrint('Purchase $element not found');
        }
        _prod =
            response.productDetails.map((e) => PurchasableProduct(e)).toList();
        _prod.sort((a, b) =>
            a.productDetails.rawPrice.compareTo(b.productDetails.rawPrice));
        _storeState = StoreState.available;
        // await _iap.restorePurchases();
        // var androidAddition =
        //     _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
        // var query = await androidAddition.queryPastPurchases();
        // debugPrint("PAST PURCHASES ${query.pastPurchases.toString()}");
      }
      store.dispatch(SetImproovePurchases(
        store.state.improovePurchases.copyWith(
          iapConnection: _iap,
          products: _prod,
          storeState: _storeState,
        ),
      ));
      // final token = await getAccessToken();
      // if (token != null) {
      //   final Response? r = await UserService().getInfo(token);
      //   //debugPrint("UE RESP ${r?.data}");
      //   if (r?.data['success'] as bool) {
      //     final User u =
      //         User.fromJson(r!.data!["user"] as Map<String, dynamic>);
      //     //debugPrint("UE USER ${u.toString()}");
      //     store.dispatch(SetUser(u));
      //     if (u.savedTrainings.isNotEmpty || u.closedTrainings.isNotEmpty) {
      //       final List<int> ids = {
      //         ...u.savedTrainings.map((s) => s.trainingId),
      //         ...u.closedTrainings.map((c) => c.trainingId),
      //       }.toList();
      //       store.dispatch(getTrainings(ids));
      //     }
      //   }
      // }
    } catch (e) {
      debugPrint("UE ERR GETINFO $e");
      cb?.call(e);
    }
  };
}

// ThunkAction<AppState> setExerciseCompleted(int trainingId, String exerciseId,
//     [Function? cb]) {
//   // Define the parameter
//   return (Store<AppState> store) async {
//     try {
//       final token = await getAccessToken();
//       if (token != null) {
//         // final Response? r =
//         //     await TrainingService().setExerciseMistakes(id, title, text, token);
//         // if (r?.data['success'] as bool) {
//         //   final Exercise e = store.state.trainings[id]!.exercises
//         //       .firstWhere((element) => element.title == title)
//         //       .copyWith(mistakes: text);
//         //   store.dispatch(SetExercise(e, id));
//         // }
//         cb?.call(null);
//       }
//     } catch (e) {
//       debugPrint("Errore in setExercise ${e.toString()}");
//       cb?.call(e.toString());
//     }
//   };
// }
