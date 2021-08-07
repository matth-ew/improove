import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:improove/screens/home_screen.dart';
import 'package:improove/screens/explore_screen.dart';
import 'package:improove/screens/profile_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

//import 'package:improove/screens/details_screen.dart';

// final selectedVideoProvider = StateProvider<Video?>((ref) => null);

// final miniPlayerControllerProvider =
//     StateProvider.autoDispose<MiniplayerController>(
//   (ref) => MiniplayerController(),
// );

class NavScreen extends StatefulWidget {
  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  // static const double _playerMinHeight = 60.0;

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  // int _selectedIndex = 3;

  final _screens = [
    HomeScreen(),
    ExploreScreen(),
    ProfileScreen(),
  ];

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      ExploreScreen(),
      ProfileScreen(),
    ];
  }
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.home),
  //         label: 'Home',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.explore),
  //         label: 'Improove',
  //       ),
  //       // BottomNavigationBarItem(
  //       //   icon: Icon(Icons.add_circle),
  //       //   label: 'Add',
  //       // ),
  //       // BottomNavigationBarItem(
  //       //   icon: Icon(Icons.fitness_center),
  //       //   label: 'Improove',
  //       // ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.person),
  //         label: 'Profile',
  //       ),
  //     ],

  List<PersistentBottomNavBarItem> _navBarsItems(ColorScheme colorScheme) {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        inactiveIcon: Icon(Icons.home_outlined),
        // title: ("Home"),
        activeColorPrimary: colorScheme.primary,
        inactiveColorPrimary: colorScheme.primary.withOpacity(.49),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.explore),
        inactiveIcon: Icon(Icons.explore_outlined),
        activeColorPrimary: colorScheme.primary,
        inactiveColorPrimary: colorScheme.primary.withOpacity(.49),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        inactiveIcon: Icon(Icons.person_outlined),
        activeColorPrimary: colorScheme.primary,
        inactiveColorPrimary: colorScheme.primary.withOpacity(.49),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // final textTheme = Theme.of(context).textTheme;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        // systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(colorScheme),
        confineInSafeArea: false,
        backgroundColor: colorScheme.background, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          // adjustScreenBottomPaddingOnCurve: false,
          // borderRadius: BorderRadius.circular(10.0),
          // colorBehindNavBar: Colors.white,
          border: BorderDirectional(
            top: BorderSide(
              color: colorScheme.onSurface.withOpacity(0.49),
            ),
          ),
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.simple, // Choose the nav bar style with this property.
      ),
    );
  }
}

        // child:
        //     // Consumer(
        //     // builder: (context, watch, _) {
        //     //     final selectedVideo = watch(selectedVideoProvider).state;
        //     //     final miniPlayerController =
        //     //         watch(miniPlayerControllerProvider).state;
        //     // return
        //     IndexedStack(index: _selectedIndex, children: _screens
        //         // ..add(
        //         //   Offstage(
        //         //     offstage: selectedVideo == null,
        //         //     child: Miniplayer(
        //         //       controller: miniPlayerController,
        //         //       minHeight: _playerMinHeight,
        //         //       maxHeight: MediaQuery.of(context).size.height,
        //         //       builder: (height, percentage) {
        //         //         if (selectedVideo == null)
        //         //           return const SizedBox.shrink();

        //         //         if (height <= _playerMinHeight + 50.0)
        //         //           return Container(
        //         //             color: Theme.of(context).scaffoldBackgroundColor,
        //         //             child: Column(
        //         //               children: [
        //         //                 Row(
        //         //                   children: [
        //         //                     Image.network(
        //         //                       selectedVideo.thumbnailUrl,
        //         //                       height: _playerMinHeight - 4.0,
        //         //                       width: 120.0,
        //         //                       fit: BoxFit.cover,
        //         //                     ),
        //         //                     Expanded(
        //         //                       child: Padding(
        //         //                         padding: const EdgeInsets.all(8.0),
        //         //                         child: Column(
        //         //                           crossAxisAlignment:
        //         //                               CrossAxisAlignment.start,
        //         //                           mainAxisSize: MainAxisSize.min,
        //         //                           children: [
        //         //                             Flexible(
        //         //                               child: Text(
        //         //                                 selectedVideo.title,
        //         //                                 overflow:
        //         //                                     TextOverflow.ellipsis,
        //         //                                 style: Theme.of(context)
        //         //                                     .textTheme
        //         //                                     .caption!
        //         //                                     .copyWith(
        //         //                                       color: Colors.white,
        //         //                                       fontWeight:
        //         //                                           FontWeight.w500,
        //         //                                     ),
        //         //                               ),
        //         //                             ),
        //         //                             Flexible(
        //         //                               child: Text(
        //         //                                 selectedVideo.author.username,
        //         //                                 overflow:
        //         //                                     TextOverflow.ellipsis,
        //         //                                 style: Theme.of(context)
        //         //                                     .textTheme
        //         //                                     .caption!
        //         //                                     .copyWith(
        //         //                                         fontWeight:
        //         //                                             FontWeight.w500),
        //         //                               ),
        //         //                             ),
        //         //                           ],
        //         //                         ),
        //         //                       ),
        //         //                     ),
        //         //                     IconButton(
        //         //                       icon: const Icon(Icons.play_arrow),
        //         //                       onPressed: () {},
        //         //                     ),
        //         //                     IconButton(
        //         //                       icon: const Icon(Icons.close),
        //         //                       onPressed: () {
        //         //                         context
        //         //                             .read(selectedVideoProvider)
        //         //                             .state = null;
        //         //                       },
        //         //                     ),
        //         //                   ],
        //         //                 ),
        //         //                 const LinearProgressIndicator(
        //         //                   value: 0.4,
        //         //                   valueColor: AlwaysStoppedAnimation<Color>(
        //         //                     Colors.red,
        //         //                   ),
        //         //                 ),
        //         //               ],
        //         //             ),
        //         //           );
        //         //         return VideoScreen();
        //         //       },
        //         //     ),
        //         // ),
        //         // ),
        //         //       );
        //         // },
        //         ),
        //   bottomNavigationBar: BottomNavigationBar(
        //     type: BottomNavigationBarType.fixed,
        //     currentIndex: _selectedIndex,
        //     onTap: (i) => setState(() => _selectedIndex = i),
        //     showSelectedLabels: false,
        //     showUnselectedLabels: false,
        //     backgroundColor: colorScheme.background,
        //     selectedItemColor: colorScheme.primary,
        //     unselectedItemColor: colorScheme.primary.withOpacity(.49),
        //     elevation: 1,
        //     // selectedFontSize: 10.0,
        //     // unselectedFontSize: 10.0,
        //     items: const [
        //       BottomNavigationBarItem(
        //         icon: Icon(Icons.home),
        //         label: 'Home',
        //       ),
        //       BottomNavigationBarItem(
        //         icon: Icon(Icons.explore),
        //         label: 'Improove',
        //       ),
        //       // BottomNavigationBarItem(
        //       //   icon: Icon(Icons.add_circle),
        //       //   label: 'Add',
        //       // ),
        //       // BottomNavigationBarItem(
        //       //   icon: Icon(Icons.fitness_center),
        //       //   label: 'Improove',
        //       // ),
        //       BottomNavigationBarItem(
        //         icon: Icon(Icons.person),
        //         label: 'Profile',
        //       ),
        //     ],
        //   ),
        // ),
  //     ),
  //   );
  // }