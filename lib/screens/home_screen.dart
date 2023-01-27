import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
// import 'package:native_updater/native_updater.dart';

class HomeScreen extends StatelessWidget {
  final PersistentTabController controller;
  static const int numNewTrainings = 4;
  // static const int trainingOfTheWeek = 2;

  void goToExplore() {
    debugPrint("GOTOEXPLORE!");
    controller.jumpToTab(1);
  }

  const HomeScreen({
    Key? key,
    required this.controller,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final Size size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    var size = MediaQuery.of(context).size;
    double trainerAvatar = min(size.width * 0.25, 250);
    return StoreConnector(
        converter: (Store<AppState> store) => _ViewModel.fromStore(store),
        onInit: (store) {
          // NativeUpdater.displayUpdateAlert(
          //   context,
          //   forceUpdate: true,
          // );
          store.dispatch(getTrainings(null, numNewTrainings));
          store.dispatch(getWeekTraining());
          store.dispatch(getLatestTrainers());
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
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: SvgPicture.asset(
                      'assets/icons/logoScritta.svg',
                      height: 30,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                  padding: const EdgeInsets.only(left: 16, right: 16),
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
                        screen: TrainingScreen(id: weekTraining!.id),
                        withNavBar: true,
                        pageTransitionAnimation: Platform.isIOS
                            ? PageTransitionAnimation.cupertino
                            : PageTransitionAnimation.fade,
                      );
                    },
                  ),
                )),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Text(
                      AppLocalizations.of(context)!.newTrainers,
                      style: textTheme.headline5?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: trainerAvatar + 30,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        const SizedBox(width: 12),
                        ...vm.newTrainersIds.map(
                          (i) {
                            var trainer = vm.trainers[i];
                            return Column(
                              children: [
                                Container(
                                  width: trainerAvatar + 8,
                                  height: trainerAvatar + 10,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 5),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    backgroundImage: trainer != null &&
                                            trainer.profileImage != null
                                        ? CachedNetworkImageProvider(
                                            trainer.profileImage!,
                                          )
                                        : null,
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  width: trainerAvatar + 8,
                                  child: Text(
                                    "${trainer?.name}",
                                    style: textTheme.subtitle2,
                                    overflow: TextOverflow.clip,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                        SizedBox(width: 12),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            AppLocalizations.of(context)!.newTrainings,
                            style: textTheme.headline5?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: TextButton(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.seeAll,
                                    // style: textTheme.button?.copyWith(
                                    //   decoration: TextDecoration.underline,
                                    // ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 15,
                                    color: colorScheme.secondary,
                                  )
                                ],
                              ),
                              onPressed: goToExplore),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.70,
                    ),
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      final training = vm.trainings[vm.ids[index]];
                      final durationString =
                          '${training?.exercisesLength} ${training?.exercisesLength == 1 ? AppLocalizations.of(context)!.exercise : AppLocalizations.of(context)!.exercises}';
                      return FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                                    id: training.id,
                                  ),
                                  withNavBar: true,
                                  pageTransitionAnimation: Platform.isIOS
                                      ? PageTransitionAnimation.cupertino
                                      : PageTransitionAnimation.fade,
                                );
                              }
                            },
                          ),
                        ),
                      );
                    }, childCount: vm.ids.length),
                  ),
                ),
                // const SliverPadding(padding: EdgeInsets.only(bottom: 8)),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50.0),
                    child: Divider(),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.only(left: 16, right: 16),
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
                            pageTransitionAnimation: Platform.isIOS
                                ? PageTransitionAnimation.cupertino
                                : PageTransitionAnimation.fade,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50.0),
                    child: Divider(),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      // height: size.width * (198 / 254) * (135 / 198),
                      // width: size.width * (198 / 254),
                      child: CtaCard(
                        preview: imgCtaFeedback,
                        tag: AppLocalizations.of(context)!.ctaFeedback,
                        onPress: () {
                          showCustomBottomSheet(
                              context, const FeedbackScreen());
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
                ),
              ],
            ),
          ));
        });
  }
}

class _ViewModel {
  final int userId;
  final Map<int, Training> trainings;
  final Map<int, User> trainers;
  final List<int> ids;
  final List<int> newTrainersIds;
  final Training? weekTraining;

  _ViewModel({
    required this.userId,
    required this.trainings,
    required this.trainers,
    required this.ids,
    required this.newTrainersIds,
    required this.weekTraining,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      userId: store.state.user.id,
      trainings: store.state.trainings,
      trainers: store.state.trainers,
      ids: store.state.newTrainingsIds,
      newTrainersIds: store.state.newTrainersIds,
      weekTraining: store.state.trainings[store.state.general.weekTrainingId],
    );
  }
}
