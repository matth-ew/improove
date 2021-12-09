import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/models/app_state.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/screens/settings_screen.dart';
import 'package:improove/screens/training_screen.dart';
import 'package:improove/widgets/custom_bottom_sheet.dart';
import 'package:improove/widgets/row_card.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';

import 'profile_widgets/local_folders.dart';
import 'profile_widgets/saved_trainings.dart';
// import 'package:video_player/video_player.dart';

class ProfileScreen extends StatelessWidget {
  final PersistentTabController controller;
  const ProfileScreen({
    Key? key,
    required this.controller,
  }) : super(key: key);

  void goToExplore() {
    debugPrint("GOTOEXPLORE!");
    controller.jumpToTab(1);
  }

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
    // final Size size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return StoreConnector(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      onInit: (Store<AppState> store) {
        store.dispatch(getInfoThunk());
      },
      builder: (BuildContext context, _ViewModel vm) {
        // var size = MediaQuery.of(context).size;
        return Scaffold(
          // Persistent AppBar that never scrolls

          appBar: AppBar(
            elevation: 0,
            title: Text(
              vm.user.name.isNotEmpty
                  ? "${vm.user.name} ${vm.user.surname}"
                  : "Improover",
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
                onPressed: () {
                  showCustomBottomSheet(context, const SettingsScreen());
                },
                icon: Icon(Icons.settings, color: colorScheme.primary),
              ),
            ],
            backgroundColor: colorScheme.background,
          ),
          body: SafeArea(
            child: DefaultTabController(
              length: 3,
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
                                if (vm.user.profileImage != null &&
                                    vm.user.profileImage!.isNotEmpty)
                                  CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    backgroundImage: CachedNetworkImageProvider(
                                      vm.user.profileImage!,
                                    ),
                                    minRadius: 20.0,
                                    maxRadius: 50.0,
                                  )
                                else
                                  const CircleAvatar(
                                    backgroundColor: Colors.grey,
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
                      tabs: const [
                        Tab(icon: Icon(Icons.video_library)),
                        Tab(icon: Icon(Icons.fitness_center_rounded)),
                        Tab(icon: Icon(Icons.history)),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          SavedTrainings(
                            savedTrainings: vm.user.savedTrainings,
                            trainings: vm.trainings,
                            removeTraining: vm.removeTraining,
                            ctaAction: goToExplore,
                          ),
                          const LocalFolders(),
                          _showClosedTrainings(
                              context, vm.user.closedTrainings, vm.trainings),
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

  Widget _showClosedTrainings(BuildContext context,
      List<ClosedTraining> closedTrainings, Map<int, Training> trainings) {
    return ListView(
      // padding: EdgeInsets.all(5),
      children: [
        ...closedTrainings.map(
          (c) {
            final Training? t = trainings[c.trainingId];
            return RowCard(
              preview: t?.preview,
              name: t?.title,
              category: t?.category,
              onTap: () {
                pushNewScreen(
                  context,
                  screen: TrainingScreen(id: c.trainingId),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _ViewModel {
  final Map<int, Training> trainings;
  final User user;
  final Function(int, [Function? cb]) removeTraining;

  _ViewModel({
    required this.trainings,
    required this.user,
    required this.removeTraining,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      trainings: store.state.trainings,
      user: store.state.user,
      removeTraining: (id, [cb]) => store.dispatch(
        removeTrainingThunk(id, cb),
      ),
    );
  }
}
