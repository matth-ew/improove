// import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:improove/redux/actions/training.dart';
import 'package:improove/redux/actions/user.dart';
import 'package:improove/screens/sub_plans_screen.dart';
import 'package:improove/utility/analytics.dart';
import 'package:improove/widgets/edit_text.dart';
import 'package:improove/widgets/my_expandable_text.dart';
import 'package:improove/screens/exercise_screen.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/widgets/row_card.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TrainingScreen extends StatelessWidget {
  final int id;
  const TrainingScreen({
    Key? key,
    this.id = -1,
  }) : super(key: key);

  Widget checkIfEdit(_ViewModel vm, int trainingId) {
    if (vm.user.id == vm.training?.trainerId) {
      return Padding(
        padding: const EdgeInsets.all(25.0),
        child: EditTextCard(
          text: vm.training?.description ?? "",
          onDone: (String text) {
            vm.setDescription(trainingId, text);
          },
        ),
      );
    } else if (vm.training != null && vm.training!.description.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(25.0),
        child: MyExpandableText(text: vm.training?.description ?? ""),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return StoreConnector(
        converter: (Store<AppState> store) => _ViewModel.fromStore(store, id),
        onInit: (Store<AppState> store) {
          if (store.state.trainings[id] == null ||
              store.state.trainings[id]!.description == "") {
            store.dispatch(getTrainingById(id));
          }
          faSetScreen("TRAINING_$id");
        },
        onDidChange: (_ViewModel? pvm, _ViewModel vm) {
          if (pvm == null || pvm.user.subscribed != vm.user.subscribed) {
            // store.dispatch(getTrainingById(id));
            vm.getTraining();
          }
        },
        builder: (BuildContext context, _ViewModel vm) {
          String? trainerImage = vm.training?.trainerImage;
          return Scaffold(
            // bottomNavigationBar: vm.user.subscribed
            //     ? null
            //     : Container(
            //         padding:
            //             const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
            //         color: colorScheme.primary,
            //         child: Column(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             SizedBox(
            //               width: double.infinity,
            //               child: ElevatedButton(
            //                 style: ElevatedButton.styleFrom(
            //                     primary: colorScheme.secondary),
            //                 child: Text("Subscribe"),
            //                 onPressed: () {
            //                   pushNewScreen(
            //                     context,
            //                     screen: const SubPlansScreen(),
            //                     withNavBar: false,
            //                     pageTransitionAnimation:
            //                         PageTransitionAnimation.cupertino,
            //                   );
            //                   },
            //               ),
            //             ),
            //             Text("As a free user, you can only preview the course",
            //                 style: textTheme.caption
            //                     ?.copyWith(color: colorScheme.onPrimary))
            //           ],
            //         )),
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  elevation: 0,
                  expandedHeight: size.height * 0.45,
                  actions: [
                    if (vm.savedTrainings.any((s) => s.trainingId == id))
                      IconButton(
                        icon: const Icon(Icons.bookmark),
                        iconSize: 32,
                        color: Colors.white,
                        onPressed: () {
                          vm.removeTraining();
                        },
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.bookmark_outline),
                        iconSize: 32,
                        splashRadius: 25,
                        color: Colors.white,
                        onPressed: () {
                          vm.saveTraining();
                        },
                      )
                  ],
                  flexibleSpace: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              ColoredBox(color: colorScheme.primary),
                          imageUrl: vm.training?.preview ?? "",
                          errorWidget: (context, url, error) =>
                              const ColoredBox(color: Colors.grey),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.6, 0.8, 1],
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.2),
                                Colors.black.withOpacity(0.4)
                              ],
                            ),
                          ),
                          alignment: Alignment.bottomLeft,
                          padding:
                              const EdgeInsets.only(left: 25.0, bottom: 50),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                            child: GestureDetector(
                              onTap: () => {
                                // if (vm.training?.trainerId != null)
                                //   pushNewScreen(
                                //     context,
                                //     screen: TrainerScreen(
                                //       id: vm.training!.trainerId,
                                //     ),
                                //     withNavBar: true,
                                //     pageTransitionAnimation:
                                //         PageTransitionAnimation.cupertino,
                                //   )
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    backgroundImage: trainerImage != null &&
                                            trainerImage != ""
                                        ? CachedNetworkImageProvider(
                                            trainerImage,
                                          )
                                        : null,
                                    radius: 27.0,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "${vm.training?.trainerName ?? ""} ${vm.training?.trainerSurname ?? ""}",
                                    style: textTheme.headline6?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 30,
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
                      Row(
                        children: [
                          Flexible(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Text(
                                vm.training?.title ?? "",
                                style: textTheme.headline4
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                      checkIfEdit(vm, id),
                    ],
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.all(5)),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      var locked = !vm.user.subscribed &&
                          index > (vm.training?.freeExercises ?? 0) - 1;
                      String? goal = vm.training?.exercises[index].goal;
                      // Goal goal = vm.training?.goals
                      //     .firstWhere((x) => x.position == index, orElse: () {
                      //   return Goal(description: "", position: -1);
                      // }) as Goal;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Column(
                          children: [
                            RowCard(
                              locked: locked,
                              preview: vm.training?.exercises[index].preview,
                              name:
                                  "${index + 1}. ${vm.training?.exercises[index].title}",
                              //category: "ESEMPIO", //vm.training?.exercises[index].category,
                              category: locked
                                  ? "🎯 ${AppLocalizations.of(context)!.lockedGoal}"
                                  : goal != null && goal.isNotEmpty
                                      ? "🎯 $goal"
                                      : null,
                              onTap: () {
                                if (locked) {
                                  pushNewScreen(
                                    context,
                                    screen: const SubPlansScreen(),
                                    withNavBar: false,
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.cupertino,
                                  );
                                } else {
                                  pushNewScreen(
                                    context,
                                    screen: ExerciseScreen(
                                      trainingId: id,
                                      id: index,
                                    ),
                                    withNavBar: false,
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.slideUp,
                                  );
                                }
                              },
                            ),
                            // Visibility(
                            //   visible: goal.description.isNotEmpty,
                            //   child: ListTile(
                            //       contentPadding:
                            //           const EdgeInsets.fromLTRB(25, 8, 25, 8),
                            //       leading: ClipRRect(
                            //         borderRadius: const BorderRadius.all(
                            //             Radius.circular(10)),
                            //         child: Container(
                            //             color: Colors.grey[200],
                            //             width: size.width * 0.23,
                            //             child: AspectRatio(
                            //               aspectRatio: 1.54,
                            //               child: const Icon(Icons
                            //                   .flag_rounded /*Icons.track_changes_outlined*/),
                            //             )),
                            //       ),
                            //       title: Text(
                            //         goal.description,
                            //         textAlign: TextAlign.left,
                            //         style: textTheme.headline6
                            //             ?.copyWith(color: colorScheme.primary),
                            //       ),
                            //       onTap: () {}),
                            // ),
                          ],
                        ),
                      );
                    },
                    childCount: vm.training?.exercises.length,
                  ),
                ),
                // const SliverPadding(padding: EdgeInsets.all(5)),
              ],
            ),
          );
        });
  }
}

class _ViewModel {
  final List<SavedTraining> savedTrainings;
  final Training? training;
  final User user;
  final Function() getTraining;
  final Function([Function? cb]) saveTraining;
  final Function([Function? cb]) removeTraining;
  final Function(int, String) setDescription;

  _ViewModel(
      {required this.savedTrainings,
      required this.training,
      required this.user,
      required this.getTraining,
      required this.saveTraining,
      required this.removeTraining,
      required this.setDescription});

  static _ViewModel fromStore(Store<AppState> store, int id) {
    return _ViewModel(
      savedTrainings: store.state.user.savedTrainings,
      user: store.state.user,
      getTraining: () => store.dispatch(getTrainingById(id)),
      setDescription: (int id, String text) =>
          store.dispatch(setTrainingDescription(id, text)),
      training: store.state.trainings[id],
      saveTraining: ([cb]) => store.dispatch(
        saveTrainingThunk(id, cb),
      ),
      removeTraining: ([cb]) => store.dispatch(
        removeTrainingThunk(id, cb),
      ),
    );
  }
}
