import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/models/app_state.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/screens/training_screen.dart';
import 'package:improove/widgets/row_card.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';

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
                        Tab(icon: Icon(Icons.video_library)),
                        Tab(icon: Icon(Icons.history)),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _showSavedTrainings(context, vm.trainings),
                          _showClosedTrainings(context, vm.trainings),
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

  Widget _showSavedTrainings(
      BuildContext context, Map<int, Training> trainings) {
    return ListView(
      // padding: EdgeInsets.all(5),
      children: [
        ...trainings.keys.map(
          (index) {
            return CardRow(
                training: trainings[index]!,
                onTap: () {
                  pushNewScreen(
                    context,
                    screen: TrainingScreen(id: index!),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                });
          },
        ),
      ],
    );
  }

  Widget _showClosedTrainings(
      BuildContext context, Map<int, Training> trainings) {
    return ListView(
      // padding: EdgeInsets.all(5),
      children: [
        ...trainings.keys.map(
          (index) {
            return CardRow(
                training: trainings[index]!,
                onTap: () {
                  pushNewScreen(
                    context,
                    screen: TrainingScreen(id: index!),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                });
          },
        ),
      ],
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
