import 'package:in_app_purchase/in_app_purchase.dart';

enum ProductStatus {
  purchasable,
  purchased,
  pending,
}

enum StoreState {
  loading,
  available,
  notAvailable,
}

class IAPConnection {
  static InAppPurchase? _instance;
  static set instance(InAppPurchase value) {
    _instance = value;
  }

  static InAppPurchase get instance {
    _instance ??= InAppPurchase.instance;
    return _instance!;
  }
}

class PurchasableProduct {
  String get id => productDetails.id;
  String get title => productDetails.title;
  String get description => productDetails.description;
  String get price => productDetails.price;
  ProductStatus status;
  ProductDetails productDetails;

  PurchasableProduct(this.productDetails) : status = ProductStatus.purchasable;
}

class ImproovePurchases {
  // final bool hasActiveSubscription;
  // final bool hasUpgrade;
  final StoreState storeState;
  final List<PurchasableProduct> products;
  final InAppPurchase? iapConnection;

  // [
  //   PurchasableProduct(
  //     'Spring is in the air',
  //     'Many dashes flying out from their nests',
  //     '\$0.99',
  //   ),
  //   PurchasableProduct(
  //     'Jet engine',
  //     'Doubles you clicks per second for a day',
  //     '\$1.99',
  //   ),
  // ]

  const ImproovePurchases({
    // this.hasActiveSubscription = false,
    // this.hasUpgrade = false,
    this.storeState = StoreState.loading,
    this.products = const [],
    this.iapConnection,
  });

  const ImproovePurchases.initial()
      :
        // hasActiveSubscription = false,
        // hasUpgrade = false,
        storeState = StoreState.loading,
        products = const [],
        iapConnection = null;

  ImproovePurchases copyWith({
    // bool? hasActiveSubscription,
    // bool? hasUpgrade,
    StoreState? storeState,
    List<PurchasableProduct>? products,
    InAppPurchase? iapConnection,
  }) {
    return ImproovePurchases(
      // hasActiveSubscription: hasActiveSubscription ?? this.hasActiveSubscription,
      // hasUpgrade: hasUpgrade ?? this.hasUpgrade,
      storeState: storeState ?? this.storeState,
      products: products ?? this.products,
      iapConnection: iapConnection ?? this.iapConnection,
    );
  }

//   dynamic toJson() => {
//         'name': name,
//         'group': group,
//       };
//   ImproovePurchases.fromJson(dynamic json)
//       : name = (json['name'] ?? "") as String,
//         group = (json['group'] ?? "") as String;
}
