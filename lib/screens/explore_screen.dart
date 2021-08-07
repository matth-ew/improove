import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/screens/training_screen.dart';
import 'package:improove/widgets/preview_card.dart';
import 'package:improove/widgets/cta_card.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/models/app_state.dart';
import 'package:improove/redux/models/models.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double heightScreen = MediaQuery.of(context).size.height;
    final Size size = MediaQuery.of(context).size;

    return StoreConnector(
        converter: (Store<AppState> store) => _ViewModel.fromStore(store),
        onInit: (store) {
          store.dispatch(getTraining());
        },
        builder: (BuildContext context, _ViewModel vm) {
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  ///Properties of app bar
                  backgroundColor: Colors.white,
                  pinned: true,
                  expandedHeight: heightScreen / 8,

                  ///Properties of the App Bar when it is expanded
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      "Improove",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisSpacing: 30),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return SizedBox(
                        child: Center(
                            child: PreviewCard(
                          name: vm.trainings[index]!.title,
                          preview: vm.trainings[index]!.preview,
                          category: vm.trainings[index]!.category,
                          avatar: vm.trainings[index]!.trainerImage,
                          id: index,
                          onTapCard: (int index) {
                            pushNewScreen(
                              context,
                              screen: TrainingScreen(id: index),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                          },
                        )),
                      );
                    },
                    childCount: vm.trainings.length,
                  ),
                ),
                SliverToBoxAdapter(
                    child: SizedBox(
                        height: size.width * (198 / 254) * (135 / 198),
                        width: size.width * (198 / 254),
                        child: CtaCard()))
              ],
            ),
          );
        });
  }
}

class _ViewModel {
  final Map<int, Training> trainings;

  _ViewModel({required this.trainings});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      trainings: store.state.trainings,
    );
  }
}
