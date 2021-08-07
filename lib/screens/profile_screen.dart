import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/models/app_state.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/screens/training_screen.dart';
// import 'package:improove/widgets/bottom_nav_bar.dart';
import 'package:improove/widgets/preview_card.dart';
import 'package:improove/widgets/cta_card.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';

const String previewPH = 'assets/images/undraw_pilates_gpdb.png';

class ProfileScreen extends StatelessWidget {
  Widget textElem(String first, String second, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        // Note: Styles for TextSpans must be explicitly defined.
        // Child text spans will inherit styles from parent
        children: <TextSpan>[
          TextSpan(
            text: '$first\n',
            style: textTheme.headline5?.copyWith(
                color: colorScheme.primary, fontWeight: FontWeight.bold),
          ),
          TextSpan(
              text: second,
              style: textTheme.subtitle1?.copyWith(color: Colors.grey)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return StoreConnector(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {
        var size = MediaQuery.of(context)
            .size; //this gonna give us total height and with of our device
        return Scaffold(
          // Persistent AppBar that never scrolls

          appBar: AppBar(
            elevation: 0,
            title: Text(
              "${vm.user.name} ${vm.user.surname}",
              style: textTheme.headline5?.copyWith(
                  color: colorScheme.primary, fontWeight: FontWeight.w600),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: Colors.grey.shade300,
                height: 1.0,
              ),
            ),
            actions: [
              IconButton(
                splashRadius: 25,
                onPressed: () {},
                icon: Icon(Icons.settings, color: colorScheme.primary),
              ),
            ],
            backgroundColor: colorScheme.background,
          ),
          body: SafeArea(
            child: DefaultTabController(
              length: 2,
              child: NestedScrollView(
                // allows you to build a list of elements that would be scrolled away till the body reached the top
                headerSliverBuilder: (context, _) {
                  return [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(25, 10, 25, 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(vm.user.profileImage),

                                  // radius: size.width * 0.2,
                                  minRadius: 20.0,
                                  maxRadius: 50.0,
                                ),
                                textElem("1", "LEVEL", context),
                                textElem("1", "END", context),
                                textElem("1", "CHALL", context),
                              ],
                            ),
                          ),
                          // Container(
                          //   color: Colors.grey.shade300,
                          //   height: 1.0,
                          // ),
                        ],
                      ),
                    ),
                  ];
                },
                // You tab view goes here
                body: Column(
                  children: <Widget>[
                    TabBar(
                      indicatorColor: colorScheme.primary,
                      labelColor: colorScheme.primary,
                      unselectedLabelColor: colorScheme.onSurface,
                      tabs: [
                        Tab(icon: Icon(Icons.directions_car)),
                        Tab(icon: Icon(Icons.directions_transit)),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _showSavedTrainings(context, vm),
                          _showClosedTrainings(vm),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _showSavedTrainings(BuildContext context, _ViewModel vm) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ListView(
        // padding: EdgeInsets.all(5),
        children: [
          ...vm.trainings.keys.map(
            (index) {
              return Center(
                child: GestureDetector(
                  onTap: () {
                    pushNewScreen(
                      context,
                      screen: TrainingScreen(id: index),
                      withNavBar: true,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  },
                  child: Container(
                    height: 120.0,
                    padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: FadeInImage(
                              height: 80,
                              fit: BoxFit.cover,
                              placeholder: const AssetImage(previewPH),
                              image: NetworkImage(vm.trainings[index]!.preview),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  vm.trainings[index]!.title,
                                  textAlign: TextAlign.left,
                                  maxLines: 1,
                                  style: textTheme.headline6
                                      ?.copyWith(color: colorScheme.primary),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  vm.trainings[index]!.category,
                                  textAlign: TextAlign.left,
                                  maxLines: 1,
                                  style: textTheme.bodyText2
                                      ?.copyWith(color: colorScheme.onSurface),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          iconSize: 30,
                          // color: ,
                          icon: const Icon(Icons.more_vert),
                          splashRadius: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ]

        // Colors.primaries.map((color) {
        //   return Container(
        //     height: 120.0,
        //     padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Container(
        //           color: color,
        //           child: FadeInImage(
        //             fit: BoxFit.cover,
        //             placeholder: const AssetImage(previewPH),
        //             image: NetworkImage(vm.trainings[0]!.preview),
        //           ),
        //         ),
        //         Container(
        //           color: color,
        //           padding: EdgeInsets.only(left: 5),
        //           child: RichText(
        //             // textAlign: TextAlign.center,
        //             text: TextSpan(
        //               // Note: Styles for TextSpans must be explicitly defined.
        //               // Child text spans will inherit styles from parent
        //               children: <TextSpan>[
        //                 TextSpan(
        //                   text: 'UE\n',
        //                   // style: textTheme.headline5?.copyWith(
        //                   //     color: colorScheme.primary, fontWeight: FontWeight.bold),
        //                 ),
        //                 TextSpan(
        //                   text: "UEUE",
        //                   // style: textTheme.subtitle1?.copyWith(color: Colors.grey)
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //         IconButton(onPressed: () {}, icon: const Icon(Icons.ac_unit)),
        //       ],
        //     ),
        //   );
        // }).toList(),
        );
  }

  Widget _showClosedTrainings(_ViewModel vm) {
    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 3,
      children: Colors.primaries.map((color) {
        return Container(color: color, height: 150.0);
      }).toList(),
    );
  }
}

class _ViewModel {
  final Map<int, Training> trainings;
  final User user;

  _ViewModel({
    required this.trainings,
    required this.user,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      trainings: store.state.trainings,
      user: store.state.user,
    );
  }
}
