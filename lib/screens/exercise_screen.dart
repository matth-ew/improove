import 'dart:io';
import 'package:flutter/material.dart';
import 'package:improove/redux/actions/user.dart';
import 'package:improove/widgets/exercise_widgets/exercise_section.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:improove/widgets/my_video_player.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/actions/training.dart';
import 'package:improove/redux/models/models.dart';
import 'package:redux/redux.dart';

class ExerciseScreen extends StatelessWidget {
  final int trainingId;
  final int id;
  const ExerciseScreen({
    Key? key,
    this.id = -1,
    this.trainingId = -1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    // String getVideo(String video) {
    //   if (video != "") {
    //     return video;
    //   } else {
    //     return "https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4";
    //   }
    // }

    return StoreConnector(
        converter: (Store<AppState> store) =>
            _ViewModel.fromStore(store, trainingId, id),
        builder: (BuildContext context, _ViewModel vm) {
          bool edit = (vm.userId == vm.training.trainerId);
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  elevation: 0,
                  collapsedHeight: size.height * 0.38,
                  expandedHeight: size.height * 0.58,
                  // leading: IconButton(
                  //   icon: const Icon(Icons.arrow_back),
                  //   iconSize: 32,
                  //   color: Colors.white,
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  // ),
                  flexibleSpace: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        top: 0,
                        child: Container(
                          color: Colors.black,
                        ),
                      ),
                      Positioned(
                        top: Platform.isIOS ? 35 : 0,
                        left: 0,
                        right: 0,
                        bottom: 25,
                        child: MyVideoPlayer(
                          video: vm.exercise!.video,
                          onEnd: () {
                            // vm.setCompleted(
                            //   trainingId,
                            //   "OBJECTID", //TODO: qui serve vm.exercise!.id
                            // );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 25,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(35),
                              topRight: Radius.circular(35),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white,
                                offset: Offset(0, 2),
                              ),
                            ],
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExerciseSection(
                        // title: AppLocalizations.of(context)!.howToPerform,
                        text: vm.exercise!.description,
                        onDone: (String text) =>
                            vm.setHow(trainingId, vm.exercise!.title, text),
                        ifEdit: edit,
                      ),
                      ExerciseSection(
                        title: AppLocalizations.of(context)!.howToPerform,
                        text: vm.exercise!.how,
                        onDone: (String text) =>
                            vm.setHow(trainingId, vm.exercise!.title, text),
                        ifEdit: edit,
                      ),
                      ExerciseSection(
                        title: AppLocalizations.of(context)!.commonMistakes,
                        text: vm.exercise!.mistakes,
                        onDone: (String text) => vm.setMistakes(
                            trainingId, vm.exercise!.title, text),
                        ifEdit: edit,
                      ),
                      ExerciseSection(
                        title: AppLocalizations.of(context)!.tips,
                        text: vm.exercise!.tips,
                        onDone: (String text) =>
                            vm.setTips(trainingId, vm.exercise!.title, text),
                        ifEdit: edit,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class _ViewModel {
  final Exercise? exercise;
  final Training training;
  final int userId;
  final Function(int, String, String) setTips;
  final Function(int, String, String) setHow;
  final Function(int, String, String) setMistakes;
  final Function(int, String) setCompleted;

  _ViewModel({
    required this.exercise,
    required this.training,
    required this.userId,
    required this.setTips,
    required this.setHow,
    required this.setMistakes,
    required this.setCompleted,
  });

  static _ViewModel fromStore(Store<AppState> store, int trainingId, int id) {
    return _ViewModel(
      userId: store.state.user.id,
      training: store.state.trainings[trainingId]!,
      exercise: store.state.trainings[trainingId]!.exercises[id],
      setTips: (int id, String title, String text) =>
          store.dispatch(setExerciseTips(id, title, text)),
      setHow: (int id, String title, String text) =>
          store.dispatch(setExerciseHow(id, title, text)),
      setMistakes: (int id, String title, String text) =>
          store.dispatch(setExerciseMistakes(id, title, text)),
      setCompleted: (int trainingId, String exerciseId) =>
          store.dispatch(setExerciseCompleted(trainingId, exerciseId)),
    );
  }
}
