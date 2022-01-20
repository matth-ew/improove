// import 'dart:async';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/actions/improove_purchases.dart';
import 'package:improove/redux/models/app_state.dart';
import 'package:improove/screens/home_screen.dart';
import 'package:improove/screens/explore_screen.dart';
import 'package:improove/screens/profile_screen.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';

//import 'package:improove/screens/details_screen.dart';

// final selectedVideoProvider = StateProvider<Video?>((ref) => null);

// final miniPlayerControllerProvider =
//     StateProvider.autoDispose<MiniplayerController>(
//   (ref) => MiniplayerController(),
// );

class NavScreen extends StatefulWidget {
  const NavScreen({Key? key}) : super(key: key);

  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  void _listenToPurchaseUpdated(
      Store<AppState> store, List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          store.dispatch(
            validateSubscriptionThunk(
              purchaseDetails,
              (String? e) {
                if (e == null) {
                  debugPrint("UE TUTTO APPOSTO");
                  Navigator.pop(context);
                } else {
                  _handleInvalidPurchase(purchaseDetails);
                }
              },
            ),
          );
          // bool valid = await _verifyPurchase(purchaseDetails);
          // if (valid) {
          //   deliverProduct(purchaseDetails);
          // } else {
          //   _handleInvalidPurchase(purchaseDetails);
          // }
        }
        // if (purchaseDetails.pendingCompletePurchase) {
        //   await InAppPurchase.instance.completePurchase(purchaseDetails);
        // }
      }
    });
  }

  void showPendingUI() {
    setState(() {
      // _purchasePending = true;
    });
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    // if (purchaseDetails.productID == _kConsumableId) {
    //   await ConsumableStore.save(purchaseDetails.purchaseID!);
    //   List<String> consumables = await ConsumableStore.load();
    //   setState(() {
    //     _purchasePending = false;
    //     _consumables = consumables;
    //   });
    // } else {
    //   setState(() {
    //     _purchases.add(purchaseDetails);
    //     _purchasePending = false;
    //   });
    // }
  }

  void handleError(IAPError error) {
    setState(() {
      // _purchasePending = false;
    });
  }

  final PersistentTabController _controller = PersistentTabController(
      // initialIndex: 0,
      );

  // int _selectedIndex = 3;

  List<Widget> _buildScreens(PersistentTabController _controller) {
    return [
      const HomeScreen(),
      const ExploreScreen(),
      ProfileScreen(controller: _controller),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;
    return [
      PersistentBottomNavBarItem(
        icon: SizedBox(width: width * 0.2, child: const Icon(Icons.home)),
        inactiveIcon: SizedBox(
            width: width * 0.2, child: const Icon(Icons.home_outlined)),
        // title: ("Home"),
        activeColorPrimary: colorScheme.primary,
        inactiveColorPrimary: colorScheme.primary.withOpacity(.49),
      ),
      PersistentBottomNavBarItem(
        icon: SizedBox(width: width * 0.2, child: const Icon(Icons.explore)),
        inactiveIcon: SizedBox(
            width: width * 0.2, child: const Icon(Icons.explore_outlined)),
        activeColorPrimary: colorScheme.primary,
        inactiveColorPrimary: colorScheme.primary.withOpacity(.49),
      ),
      PersistentBottomNavBarItem(
        icon: SizedBox(width: width * 0.2, child: const Icon(Icons.person)),
        inactiveIcon: SizedBox(
            width: width * 0.2, child: const Icon(Icons.person_outlined)),
        activeColorPrimary: colorScheme.primary,
        inactiveColorPrimary: colorScheme.primary.withOpacity(.49),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // final textTheme = Theme.of(context).textTheme;
    return StoreBuilder(
        // converter: (Store<AppState> store) => _ViewModel.fromStore(store),
        onInit: (Store<AppState> store) {
      store.dispatch(initImproovePurchases());
      final Stream<List<PurchaseDetails>> purchaseUpdated =
          InAppPurchase.instance.purchaseStream;
      // setState(() {
      _subscription = purchaseUpdated.listen(
        (purchaseDetailsList) {
          _listenToPurchaseUpdated(store, purchaseDetailsList);
        },
        onDone: () {
          _subscription?.cancel();
        },
        onError: (error) {
          // handle error here.
        },
      );
      // },);
    }, onDispose: (Store<AppState> store) {
      _subscription?.cancel();
      super.dispose();
    }, builder: (BuildContext context, _) {
      return PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(_controller),
        items: _navBarsItems(context),
        confineInSafeArea: true,
        backgroundColor: colorScheme.background, // Default is Colors.white.
        // handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        // stateManagement: true, // Default is true.
        // hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          border: BorderDirectional(
            top: BorderSide(
              color: colorScheme.onSurface.withOpacity(0.1),
            ),
          ),
        ),
        // popAllScreensOnTapOfSelectedTab: true,
        // popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          // curve: Curves.ease,
          // duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.simple, // Choose the nav bar style with this property.
      );
    });
  }
}
