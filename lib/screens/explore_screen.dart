import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:improove/const/images.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/screens/training_screen.dart';
import 'package:improove/screens/webview_screen.dart';
import 'package:improove/utility/analytics.dart';
import 'package:improove/widgets/preview_card.dart';
import 'package:improove/widgets/cta_card.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/models/models.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Future<void> _refresh(Function load) {
      final completer = Completer();
      load(completer);
      return completer.future;
    }

    return StoreConnector(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      onInit: (store) {
        store.dispatch(getTrainings());
      },
      builder: (BuildContext context, _ViewModel vm) {
        final Size fontSize = (TextPainter(
                text: TextSpan(
                    text: AppLocalizations.of(context)!.explore,
                    style: textTheme.headline4),
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                textDirection: TextDirection.ltr)
              ..layout())
            .size;
        return Scaffold(
          body: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, _) {
                return [
                  SliverAppBar(
                    ///Properties of app bar
                    backgroundColor: Colors.white,
                    pinned: true,
                    expandedHeight: fontSize.height + 30,
                    primary: true,

                    ///Properties of the App Bar when it is expanded
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: const EdgeInsetsDirectional.only(
                          start: 15, bottom: 15, end: 15),
                      title: FittedBox(
                        child: Text(
                          AppLocalizations.of(context)!.explore,
                          style: textTheme.headline5?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: RefreshIndicator(
                backgroundColor: colorScheme.primary,
                color: colorScheme.background,
                onRefresh: () => _refresh(vm.loadTrainings),
                child: CustomScrollView(
                  slivers: [
                    SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                                  screen: TrainingScreen(id: training.id),
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
                    const SliverPadding(padding: EdgeInsets.all(15)),
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        height: size.width * (198 / 254) * (135 / 198),
                        width: size.width * (198 / 254),
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
                                  url:
                                      AppLocalizations.of(context)!.landingUrl),
                              withNavBar: false,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                          },
                        ),
                      ),
                    ),
                    const SliverPadding(padding: EdgeInsets.all(15)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel {
  final int userId;
  final Map<int, Training> trainings;
  final List<int> ids;
  final Function([Completer? cb]) loadTrainings;

  _ViewModel({
    required this.userId,
    required this.trainings,
    required this.ids,
    required this.loadTrainings,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      userId: store.state.user.id,
      trainings: store.state.trainings,
      ids: store.state.exploreTrainingsIds,
      loadTrainings: ([cb]) => store.dispatch(
        getTrainings([], 0, cb),
      ),
    );
  }
}
