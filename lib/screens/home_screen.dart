import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:improove/screens/feedback_screen.dart';
import 'package:improove/screens/training_screen.dart';
import 'package:improove/screens/webview_screen.dart';
import 'package:improove/widgets/cta_card.dart';
import 'package:improove/const/text.dart';
import 'package:improove/const/images.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/models/app_state.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/widgets/custom_bottom_sheet.dart';
import 'package:improove/widgets/preview_card.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';

class HomeScreen extends StatelessWidget {
  static const int numNewTrainings = 4;
  static const int trainingOfTheDay = 6;

  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final Size size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // var size = MediaQuery.of(context).size;
    return StoreConnector(
        converter: (Store<AppState> store) =>
            _ViewModel.fromStore(store, trainingOfTheDay),
        onInit: (store) {
          store.dispatch(getTrainings(null, numNewTrainings));
          store.dispatch(getTrainingById(trainingOfTheDay));
        },
        builder: (BuildContext context, _ViewModel vm) {
          final List<Training> trainingList = vm.trainings.values.toList();
          return Scaffold(
              body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: Text(
                      "Training of the week 🔥",
                      style: textTheme.headline5?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: PreviewCard(
                    name: vm.dailyTraining?.title,
                    duration:
                        '${vm.dailyTraining?.exercisesLength ?? 0} ${vm.dailyTraining?.exercisesLength == 1 ? 'exercise' : 'exercises'}',
                    preview: vm.dailyTraining?.preview,
                    category: vm.dailyTraining?.category,
                    avatar: vm.dailyTraining?.trainerImage,
                    widthRatio: 0.96,
                    heightRatio: 0.70,
                    id: trainingOfTheDay,
                    trainerId: vm.dailyTraining?.trainerId,
                    onTapCard: (int index) {
                      pushNewScreen(
                        context,
                        screen: TrainingScreen(id: vm.dailyTraining!.id),
                        withNavBar: true,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                  ),
                )),
                const SliverPadding(padding: EdgeInsets.only(bottom: 15)),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    // height: size.width * (198 / 254) * (135 / 198),
                    // width: size.width * (198 / 254),
                    child: CtaCard(
                      preview: imgCtaTraining,
                      tag: ctaBecameTrainer,
                      onPress: () {
                        pushNewScreen(
                          context,
                          screen:
                              const WebViewScreen(url: "https://improove.fit"),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                    ),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.all(15)),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: Text(
                      "Newest trainings 🚀",
                      style: textTheme.headline5?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600),
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
                    final durationString =
                        '${trainingList[index].exercisesLength} ${trainingList[index].exercisesLength == 1 ? 'exercise' : 'exercises'}';
                    return Center(
                      child: PreviewCard(
                        name: trainingList[index].title,
                        duration: durationString,
                        preview: trainingList[index].preview,
                        category: trainingList[index].category,
                        avatar: trainingList[index].trainerImage,
                        widthRatio: 0.45,
                        id: index,
                        trainerId: trainingList[index].trainerId,
                        onTapCard: (int index) {
                          pushNewScreen(
                            context,
                            screen: TrainingScreen(id: trainingList[index].id),
                            withNavBar: true,
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        },
                      ),
                    );
                  }, childCount: trainingList.length),
                ),
                const SliverPadding(padding: EdgeInsets.all(15)),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    // height: size.width * (198 / 254) * (135 / 198),
                    // width: size.width * (198 / 254),
                    child: CtaCard(
                      preview: imgCtaFeedback,
                      tag: ctaFeedback,
                      onPress: () {
                        showCustomBottomSheet(context, const FeedbackScreen());
                        // pushNewScreen(
                        //   context,
                        //   screen:
                        //       const WebViewScreen(url: "https://improove.fit"),
                        //   withNavBar: false,
                        //   pageTransitionAnimation:
                        //       PageTransitionAnimation.cupertino,
                        // );
                      },
                    ),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.all(35)),
              ],
            ),
          ));
        });
  }
}

class _ViewModel {
  final Map<int, Training> trainings;
  final Training? dailyTraining;

  _ViewModel({required this.trainings, required this.dailyTraining});

  static _ViewModel fromStore(Store<AppState> store, int id) {
    return _ViewModel(
        trainings: store.state.newTrainings,
        dailyTraining: store.state.trainings[id]);
  }
}
