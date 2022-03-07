import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/utility/video.dart';
import 'package:improove/widgets/row_card.dart';
import 'package:redux/redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:math';

import 'ct_exercise_details.dart';

class CtExercisesList extends StatelessWidget {
  const CtExercisesList({Key? key}) : super(key: key);

  showDeleteDialog(deleteFunction, context) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.ct_wantDeleteVideo),
              // content: Text(AppLocalizations.of(context)!.ct_deleteLoseVideo),
              actions: [
                TextButton(
                  child: Text(AppLocalizations.of(context)!.no),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    AppLocalizations.of(context)!.delete,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    deleteFunction();
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    // final step = h.useState(0);
    final Size size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final iconTheme = Theme.of(context).iconTheme;

    // final controller = h.useTextEditingController();

    return StoreConnector(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {
        // String? trainerImage = vm.training?.trainerImage;
        List<Exercise> exercises = vm.inCreationTraining.exercises;
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: colorScheme.background,
            iconTheme: iconTheme.copyWith(color: colorScheme.onSurface),
            titleTextStyle: textTheme.headline6?.copyWith(
              color: colorScheme.onBackground,
            ),
            title: Text(vm.inCreationTraining.title),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
            // color: colorScheme.primary,

            decoration: BoxDecoration(
              border: BorderDirectional(
                top: BorderSide(
                  color: colorScheme.onSurface.withOpacity(0.1),
                ),
              ),
            ),
            child: ElevatedButton(
              onPressed: vm.inCreationTraining.exercises.isEmpty
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (context) => WillPopScope(
                          onWillPop: () {
                            return Future.value(false);
                          },
                          child: Center(
                            child: Container(
                              width: 60.0,
                              height: 60.0,
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Platform.isIOS
                                    ? Theme(
                                        data: ThemeData(
                                            cupertinoOverrideTheme:
                                                const CupertinoThemeData(
                                                    brightness:
                                                        Brightness.dark)),
                                        child:
                                            const CupertinoActivityIndicator())
                                    : const CircularProgressIndicator(
                                        color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      );
                      vm.uploadTraining((String? e) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                            content:
                                const Text("Corso inviato in approvazione"),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.of(context)
                                      .popUntil((route) => route.isFirst),
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  )),
                            ],
                          ),
                        );
                      });
                    },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(min(size.width * 0.8, 350), 50),
                shape: const StadiumBorder(),
              ),
              child: Text(
                AppLocalizations.of(context)!.ct_publish,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              // padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                // alignment: Alignment,
                padding: const EdgeInsets.symmetric(vertical: 15),
                constraints: BoxConstraints(
                    minWidth: size.width,
                    minHeight: size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom -
                        150),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: exercises.isNotEmpty,
                      child: ReorderableListView(
                        scrollController: ScrollController(),
                        children: [
                          for (int index = 0;
                              index < exercises.length;
                              index += 1)
                            RowCard(
                              key: Key('$index'),
                              maxLines: 2,
                              preview: exercises[index].preview,
                              name: "${index + 1}. ${exercises[index].title}",
                              //category: "ESEMPIO", //vm.training?.exercises[index].category,
                              category: exercises[index].goal.isNotEmpty
                                  ? "🎯 ${exercises[index].goal}"
                                  : null,
                              actions: [
                                IconButton(
                                  onPressed: () => showDeleteDialog(
                                      () => vm
                                          .removeExercise(exercises[index].id),
                                      context),
                                  icon: const Icon(Icons.delete_forever),
                                ),
                                const Icon(Icons.drag_indicator)
                              ],
                              // onTap: () {
                              //   if (locked) {
                              //     pushNewScreen(
                              //       context,
                              //       screen: const SubPlansScreen(),
                              //       withNavBar: false,
                              //       pageTransitionAnimation: Platform.isIOS
                              //           ? PageTransitionAnimation.cupertino
                              //           : PageTransitionAnimation.fade,
                              //     );
                              //   } else {
                              //     pushNewScreen(
                              //       context,
                              //       screen: ExerciseScreen(
                              //         trainingId: id,
                              //         id: index,
                              //       ),
                              //       withNavBar: false,
                              //       pageTransitionAnimation:
                              //           PageTransitionAnimation.slideUp,
                              //     );
                              //   }
                              // },
                            ),
                        ],
                        onReorder: (oldIndex, newIndex) {
                          vm.reorderExercise(oldIndex, newIndex);
                        },
                        shrinkWrap: true,
                      ),
                      replacement: const SizedBox.shrink(),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 25.0),
                    //   child: SvgPicture.asset(
                    //     'assets/icons/createTraining.svg',
                    //     width: min(size.width * 0.8, 300),
                    //   ),
                    // ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: exercises.isEmpty,
                            child: Text(
                              AppLocalizations.of(context)!.ct_add_exercise,
                              style: textTheme.headline6?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                              onPressed: () => pickTrimVideo(
                                    context,
                                    pop: false,
                                    folderName: "inCreationTraining",
                                    onSave: (String path) async {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              ExerciseDetails(video: path),
                                        ),
                                      );
                                      // vm.addLocalVideo(
                                      //   LocalVideo(
                                      //     path: path,
                                      //     group: widget.videoFolder.group,
                                      //   ),
                                      //   (String? e) {
                                      //     ScaffoldMessenger.of(context).showSnackBar(
                                      //       SnackBar(
                                      //         backgroundColor: colorScheme.primary,
                                      //         duration: const Duration(seconds: 3),
                                      //         behavior: SnackBarBehavior.floating,
                                      //         content: Text(
                                      //             AppLocalizations.of(context)!
                                      //                 .videoSavedSuccess),
                                      //       ),
                                      //     );
                                      //   },
                                      // );
                                    },
                                  ),
                              child: const Icon(Icons.add),
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(50, 50),
                                shape: const CircleBorder(),
                              ))
                        ],
                      ),
                    ),
                    const SizedBox.shrink(),
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
  final User user;
  final Training inCreationTraining;
  final Function(String) removeExercise;
  final Function(int, int) reorderExercise;
  final Function([Function? cb]) uploadTraining;

  _ViewModel({
    required this.user,
    required this.inCreationTraining,
    required this.removeExercise,
    required this.reorderExercise,
    required this.uploadTraining,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      user: store.state.user,
      inCreationTraining: store.state.inCreationTraining,
      removeExercise: (String id) => store.dispatch(RemoveICTExercise(id)),
      reorderExercise: (int oldP, int newP) =>
          store.dispatch(ReorderICTExercise(oldP, newP)),
      uploadTraining: ([Function? cb]) =>
          store.dispatch(uploadTrainingThunk(cb)),
    );
  }
}
