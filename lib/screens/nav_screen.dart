// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:improove/screens/home_screen.dart';
import 'package:improove/screens/explore_screen.dart';
import 'package:improove/screens/profile_screen.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

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
//   StreamSubscription<List<PurchaseDetails>>? _subscription;

//   @override
//   void initState() {
//     final Stream<List<PurchaseDetails>> purchaseUpdated =
//         InAppPurchase.instance.purchaseStream;
//     _subscription = purchaseUpdated.listen((purchaseDetailsList) {
//       _listenToPurchaseUpdated(purchaseDetailsList);
//     }, onDone: () {
//       _subscription?.cancel();
//     }, onError: (error) {
//       // handle error here.
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _subscription?.cancel();
//     super.dispose();
//   }

//   void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
//   purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
//     if (purchaseDetails.status == PurchaseStatus.pending) {
//       _showPendingUI();
//     } else {
//       if (purchaseDetails.status == PurchaseStatus.error) {
//         _handleError(purchaseDetails.error!);
//       } else if (purchaseDetails.status == PurchaseStatus.purchased ||
//                  purchaseDetails.status == PurchaseStatus.restored) {
//         bool valid = await _verifyPurchase(purchaseDetails);
//         if (valid) {
//           _deliverProduct(purchaseDetails);
//         } else {
//           _handleInvalidPurchase(purchaseDetails);
//         }
//       }
//       if (purchaseDetails.pendingCompletePurchase) {
//         await InAppPurchase.instance
//             .completePurchase(purchaseDetails);
//       }
//     }
//   });
// }

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
  }
}
