// import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:improove/redux/actions/training.dart';
import 'package:improove/redux/actions/user.dart';
import 'package:improove/screens/trainer_screen.dart';
import 'package:improove/widgets/edit_text.dart';
import 'package:improove/widgets/my_expandable_text.dart';
import 'package:improove/widgets/preview_card.dart';
import 'package:improove/screens/exercise_screen.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/models/app_state.dart';
import 'package:improove/redux/models/models.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TrainingScreen extends StatelessWidget {
  final int id;
  const TrainingScreen({
    Key? key,
    this.id = -1,
  }) : super(key: key);

  Widget checkIfEdit(_ViewModel vm, int trainingId) {
    if (vm.user.id == vm.training!.trainerId) {
      return EditTextCard(
        text: vm.training?.description ?? "",
        onDone: (String text) {
          vm.setDescription(trainingId, text);
        },
      );
    } else {
      return MyExpandableText(text: vm.training?.description ?? "");
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
          if (store.state.trainings[id]!.description == "") {
            store.dispatch(getTrainingById(id));
          }
        },
        builder: (BuildContext context, _ViewModel vm) {
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  elevation: 0,
                  expandedHeight: size.height * 0.45,
                  // leading: IconButton(
                  //   icon: const Icon(Icons.arrow_back),
                  //   iconSize: 32,
                  //   color: Colors.white,
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  // ),
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
                          imageUrl: vm.training!.preview,
                          errorWidget: (context, url, error) =>
                              ColoredBox(color: Colors.grey),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 35,
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
                      Positioned(
                        bottom: 3,
                        right: 35,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          child: GestureDetector(
                            onTap: () => {
                              pushNewScreen(
                                context,
                                screen: TrainerScreen(
                                  id: vm.training!.trainerId,
                                ),
                                withNavBar: true,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino,
                              )
                            },
                            child: CachedNetworkImage(
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                // placeholder: const AssetImage(
                                //     "assets/images/trainer_avatar.jpg"),
                                imageUrl: vm.training!.trainerImage),
                          ),
                        ),
                        // Container(
                        //   height: 35,
                        //   decoration: const BoxDecoration(
                        //     borderRadius: BorderRadius.only(
                        //       topLeft: Radius.circular(35),
                        //       topRight: Radius.circular(35),
                        //     ),
                        //     color: Colors.white,
                        //   ),
                        // ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text(
                          vm.training!.title,
                          style: textTheme.headline4
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: checkIfEdit(vm, id)),
                    ],
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.all(5)),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: size.width * (92 / 254) * (135 / 92),
                    width: size.width,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(left: 19.0, right: 19.0),
                      scrollDirection: Axis.horizontal,
                      itemCount: vm.training!.exercises.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 6, right: 6),
                          child: PreviewCard(
                            preview: vm.training!.exercises[index].preview,
                            name: vm.training!.exercises[index].title,
                            // avatar: vm.training!.trainerImage,
                            id: index,
                            onTapCard: (int index) {
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
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.all(5)),
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
  final Function([Function? cb]) saveTraining;
  final Function([Function? cb]) removeTraining;
  final Function(int, String) setDescription;

  _ViewModel(
      {required this.savedTrainings,
      required this.training,
      required this.user,
      required this.saveTraining,
      required this.removeTraining,
      required this.setDescription});

  static _ViewModel fromStore(Store<AppState> store, int id) {
    return _ViewModel(
      savedTrainings: store.state.user.savedTrainings,
      user: store.state.user,
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
