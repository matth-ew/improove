import 'package:flutter/material.dart';
import 'package:improove/screens/feedback_screen.dart';
import 'package:improove/screens/training_screen.dart';
import 'package:improove/screens/webview_screen.dart';
import 'package:improove/utility/analytics.dart';
import 'package:improove/widgets/cta_card.dart';
import 'package:improove/const/images.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/widgets/custom_bottom_sheet.dart';
import 'package:improove/widgets/long_card.dart';
import 'package:improove/widgets/preview_card.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  final PersistentTabController controller;
  static const int numNewTrainings = 4;
  // static const int trainingOfTheWeek = 2;

  const HomeScreen({Key? key, required this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final Size size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // var size = MediaQuery.of(context).size;
    return StoreConnector(
        converter: (Store<AppState> store) => _ViewModel.fromStore(store),
        onInit: (store) {
          store.dispatch(getTrainings(null, numNewTrainings));
          store.dispatch(getWeekTraining());
          // store.dispatch(getTrainingById(trainingOfTheWeek));
        },
        builder: (BuildContext context, _ViewModel vm) {
          Training? weekTraining = vm.weekTraining;
          // if (vm.weekTrainingId != null)
          //   Training? weekTraining = vm.trainings[vm.weekTrainingId];

          return Scaffold(
              body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: Text(
                      AppLocalizations.of(context)!.trainingWeek,
                      style: textTheme.headline5?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: LongCard(
                    name: weekTraining?.title,
                    duration:
                        '${weekTraining?.exercisesLength ?? 0} ${weekTraining?.exercisesLength == 1 ? AppLocalizations.of(context)!.exercise : AppLocalizations.of(context)!.exercises}',
                    preview: weekTraining?.preview,
                    category: weekTraining?.category,
                    avatar: weekTraining?.trainerImage,
                    widthRatio: 0.96,
                    heightRatio: 0.60,
                    id: weekTraining?.id,
                    trainerId: weekTraining?.trainerId,
                    onTapCard: (int index) {
                      pushNewScreen(
                        context,
                        screen: TrainingScreen(
                            id: weekTraining!.id, controller: controller),
                        withNavBar: true,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                  ),
                )),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: Text(
                      AppLocalizations.of(context)!.newTrainings,
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
                    childAspectRatio: 0.90,
                  ),
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    final training = vm.trainings[vm.ids[index]];
                    final durationString =
                        '${training?.exercisesLength} ${training?.exercisesLength == 1 ? AppLocalizations.of(context)!.exercise : AppLocalizations.of(context)!.exercises}';
                    return Center(
                      child: PreviewCard(
                        name: training?.title,
                        duration: durationString,
                        preview: training?.preview,
                        category: training?.category,
                        avatar: training?.trainerImage,
                        widthRatio: 0.45,
                        id: index,
                        trainerId: training?.trainerId,
                        onTapCard: (int index) {
                          if (training != null) {
                            pushNewScreen(
                              context,
                              screen: TrainingScreen(
                                  id: training.id, controller: controller),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                          }
                        },
                      ),
                    );
                  }, childCount: vm.ids.length),
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 50)),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    // height: size.width * (198 / 254) * (135 / 198),
                    // width: size.width * (198 / 254),
                    child: CtaCard(
                      preview: imgCtaTraining,
                      tag: AppLocalizations.of(context)!.ctaBecameTrainer,
                      onPress: () {
                        faCustomEvent(
                          "CTA_BECOME_TRAINER",
                          {
                            "user": vm.userId,
                          },
                        );
                        pushNewScreen(
                          context,
                          screen: WebViewScreen(
                              url: AppLocalizations.of(context)!.landingUrl),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                    ),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.all(25)),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    // height: size.width * (198 / 254) * (135 / 198),
                    // width: size.width * (198 / 254),
                    child: CtaCard(
                      preview: imgCtaFeedback,
                      tag: AppLocalizations.of(context)!.ctaFeedback,
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
  final int userId;
  final Map<int, Training> trainings;
  final List<int> ids;
  final Training? weekTraining;

  _ViewModel({
    required this.userId,
    required this.trainings,
    required this.ids,
    required this.weekTraining,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      userId: store.state.user.id,
      trainings: store.state.trainings,
      ids: store.state.newTrainingsIds,
      weekTraining: store.state.trainings[store.state.general.weekTrainingId],
    );
  }
}
