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
          store.dispatch(getTrainings());
        },
        builder: (BuildContext context, _ViewModel vm) {
          final List<Training> trainingList = vm.trainings.values.toList();
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  ///Properties of app bar
                  backgroundColor: Colors.white,
                  pinned: true,
                  expandedHeight: heightScreen / 8,

                  ///Properties of the App Bar when it is expanded
                  flexibleSpace: const FlexibleSpaceBar(
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 30,
                    // crossAxisSpacing: 0,
                    childAspectRatio: 0.92,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Center(
                        child: PreviewCard(
                          name: trainingList[index].title,
                          preview: trainingList[index].preview,
                          category: trainingList[index].category,
                          avatar: trainingList[index].trainerImage,
                          widthRatio: 0.45,
                          id: index,
                          trainerId: trainingList[index].trainerId,
                          onTapCard: (int index) {
                            pushNewScreen(
                              context,
                              screen:
                                  TrainingScreen(id: trainingList[index].id),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                          },
                        ),
                      );
                    },
                    childCount: trainingList.length,
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.all(15)),
                SliverToBoxAdapter(
                    child: SizedBox(
                        height: size.width * (198 / 254) * (135 / 198),
                        width: size.width * (198 / 254),
                        child: const CtaCard()))
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
