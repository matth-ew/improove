// import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:improove/redux/actions/training.dart';
import 'package:improove/redux/actions/user.dart';
import 'package:improove/screens/trainer_screen.dart';
import 'package:improove/widgets/edit_text.dart';
import 'package:improove/widgets/my_expandable_text.dart';
import 'package:improove/screens/exercise_screen.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/widgets/row_card.dart';
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
        },
        builder: (BuildContext context, _ViewModel vm) {
          String? trainerImage = vm.training?.trainerImage;
          return Scaffold(
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
                      Positioned(
                        bottom: 0,
                        right: 35,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          child: GestureDetector(
                            onTap: () => {
                              if (vm.training?.trainerId != null)
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
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  trainerImage != null && trainerImage != ""
                                      ? CachedNetworkImageProvider(
                                          trainerImage,
                                        )
                                      : null,
                              radius: 30.0,
                            ),
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
                    return RowCard(
                      preview: vm.training?.exercises[index].preview,
                      name:
                          "${index + 1}. ${vm.training?.exercises[index].title}",
                      category:
                          "ESEMPIO", //vm.training?.exercises[index].category,
                      onTap: () {
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
                    );
                  }, childCount: vm.training?.exercises.length),
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
