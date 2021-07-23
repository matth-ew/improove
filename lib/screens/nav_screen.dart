import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:improove/data.dart';
import 'package:improove/screens/home_screen.dart';
import 'package:improove/screens/explore_screen.dart';
import 'package:improove/screens/profile_screen.dart';
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

  int _selectedIndex = 0;
  // int _selectedIndex = 3;

  final _screens = [
    HomeScreen(),
    ExploreScreen(),
    const Scaffold(body: Center(child: Text('Improove'))),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        // systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body:
            // Consumer(
            // builder: (context, watch, _) {
            //     final selectedVideo = watch(selectedVideoProvider).state;
            //     final miniPlayerController =
            //         watch(miniPlayerControllerProvider).state;
            // return
            Stack(
                children: _screens
                    .asMap()
                    .map((i, screen) => MapEntry(
                          i,
                          Offstage(
                            offstage: _selectedIndex != i,
                            child: screen,
                          ),
                        ))
                    .values
                    .toList()
                // ..add(
                //   Offstage(
                //     offstage: selectedVideo == null,
                //     child: Miniplayer(
                //       controller: miniPlayerController,
                //       minHeight: _playerMinHeight,
                //       maxHeight: MediaQuery.of(context).size.height,
                //       builder: (height, percentage) {
                //         if (selectedVideo == null)
                //           return const SizedBox.shrink();

                //         if (height <= _playerMinHeight + 50.0)
                //           return Container(
                //             color: Theme.of(context).scaffoldBackgroundColor,
                //             child: Column(
                //               children: [
                //                 Row(
                //                   children: [
                //                     Image.network(
                //                       selectedVideo.thumbnailUrl,
                //                       height: _playerMinHeight - 4.0,
                //                       width: 120.0,
                //                       fit: BoxFit.cover,
                //                     ),
                //                     Expanded(
                //                       child: Padding(
                //                         padding: const EdgeInsets.all(8.0),
                //                         child: Column(
                //                           crossAxisAlignment:
                //                               CrossAxisAlignment.start,
                //                           mainAxisSize: MainAxisSize.min,
                //                           children: [
                //                             Flexible(
                //                               child: Text(
                //                                 selectedVideo.title,
                //                                 overflow:
                //                                     TextOverflow.ellipsis,
                //                                 style: Theme.of(context)
                //                                     .textTheme
                //                                     .caption!
                //                                     .copyWith(
                //                                       color: Colors.white,
                //                                       fontWeight:
                //                                           FontWeight.w500,
                //                                     ),
                //                               ),
                //                             ),
                //                             Flexible(
                //                               child: Text(
                //                                 selectedVideo.author.username,
                //                                 overflow:
                //                                     TextOverflow.ellipsis,
                //                                 style: Theme.of(context)
                //                                     .textTheme
                //                                     .caption!
                //                                     .copyWith(
                //                                         fontWeight:
                //                                             FontWeight.w500),
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                       ),
                //                     ),
                //                     IconButton(
                //                       icon: const Icon(Icons.play_arrow),
                //                       onPressed: () {},
                //                     ),
                //                     IconButton(
                //                       icon: const Icon(Icons.close),
                //                       onPressed: () {
                //                         context
                //                             .read(selectedVideoProvider)
                //                             .state = null;
                //                       },
                //                     ),
                //                   ],
                //                 ),
                //                 const LinearProgressIndicator(
                //                   value: 0.4,
                //                   valueColor: AlwaysStoppedAnimation<Color>(
                //                     Colors.red,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           );
                //         return VideoScreen();
                //       },
                //     ),
                // ),
                // ),
                //       );
                // },
                ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: colorScheme.background,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: colorScheme.primary.withOpacity(.49),
          elevation: 1,
          // selectedFontSize: 10.0,
          // unselectedFontSize: 10.0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Explore',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.add_circle),
            //   label: 'Add',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: 'Improove',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
