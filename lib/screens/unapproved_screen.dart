import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:improove/const/images.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/screens/training_screen.dart';
import 'package:improove/screens/webview_screen.dart';
import 'package:improove/utility/analytics.dart';
import 'package:improove/widgets/long_card.dart';
import 'package:improove/widgets/preview_card.dart';
import 'package:improove/widgets/cta_card.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/models/models.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UnapprovedScreen extends StatelessWidget {
  const UnapprovedScreen({
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
        store.dispatch(getUnapprovedTrainings());
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
          appBar: AppBar(
            foregroundColor: colorScheme.primary,
            elevation: 1,
            backgroundColor: colorScheme.background,
            title: const Text("Controllo corsi"),
          ),
          body: RefreshIndicator(
            backgroundColor: colorScheme.primary,
            color: colorScheme.background,
            onRefresh: () => _refresh(vm.loadTrainings),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.7,
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
                            // ratio: 16 / 9,
                            // widthRatio: 0.5,
                            // heightRatio: 0.60,
                            id: index,
                            trainerId: training?.trainerId,
                            onTapCard: (int index) {
                              if (training != null) {
                                pushNewScreen(
                                  context,
                                  screen: TrainingScreen(id: training.id),
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
              ],
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
      ids: store.state.unapprovedTrainingsIds,
      loadTrainings: ([cb]) => store.dispatch(
        getUnapprovedTrainings(cb),
      ),
    );
  }
}
