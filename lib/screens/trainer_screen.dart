import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:improove/redux/actions/trainer.dart';
import 'package:improove/widgets/edit_text.dart';
import 'package:improove/widgets/my_expandable_text.dart';
import 'package:improove/widgets/preview_card.dart';
import 'package:improove/widgets/button_image_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/screens/training_screen.dart';
import 'package:improove/redux/models/app_state.dart';
import 'package:improove/redux/models/models.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';

class TrainerScreen extends StatelessWidget {
  final int id;
  const TrainerScreen({
    Key? key,
    this.id = -1,
  }) : super(key: key);

  Widget checkIfEdit(_ViewModel vm, int trainerId) {
    if (vm.user.id == trainerId) {
      return Padding(
        padding: const EdgeInsets.all(25.0),
        child: EditTextCard(
          text: vm.trainer?.trainerDescription ?? "",
          onDone: (String text) {
            vm.setDescription(trainerId, text);
          },
        ),
      );
    } else if (vm.trainer != null &&
        vm.trainer!.trainerDescription.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(25.0),
        child: MyExpandableText(text: vm.trainer?.trainerDescription ?? ""),
      );
    } else
      return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return StoreConnector(
        converter: (Store<AppState> store) => _ViewModel.fromStore(store, id),
        onInit: (Store<AppState> store) {
          if (store.state.trainers[id] == null) {
            debugPrint(id.toString());
            store.dispatch(getTrainerById(id));
          }
        },
        builder: (BuildContext context, _ViewModel vm) {
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  elevation: 0,
                  expandedHeight: size.height * 0.35,
                  // leading: IconButton(
                  //   icon: const Icon(Icons.arrow_back),
                  //   iconSize: 25,
                  //   color: Colors.white,
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  // ),
                  flexibleSpace: Stack(
                    children: [
                      if (vm.trainer != null &&
                          vm.trainer!.trainerImage != null &&
                          vm.trainer!.trainerImage != "")
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                ColoredBox(color: colorScheme.primary),
                            imageUrl: vm.trainer!.trainerImage!,
                            errorWidget: (context, url, error) =>
                                ColoredBox(color: colorScheme.primary),
                          ),
                        ),
                      if (vm.user.id == id)
                        Positioned(
                          right: 0,
                          bottom: 55,
                          child: ButtonImagePicker(
                            callback: (File fileToSave) {
                              vm.setTrainerPicture(fileToSave, id);
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
                const SliverPadding(padding: EdgeInsets.all(2)),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (vm.trainer?.profileImage != null &&
                              vm.user.profileImage!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: CachedNetworkImageProvider(
                                  vm.trainer!.profileImage!,
                                ),
                                radius: 35,
                              ),
                            ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: Text(
                                '${vm.trainer?.name ?? ""} ${vm.trainer?.surname ?? ""}',
                                style: textTheme.headline4
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                      checkIfEdit(vm, id),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 25.0,
                          right: 25.0,
                          top: 35.0,
                          bottom: 25.0,
                        ),
                        child: Text(
                          "My Courses",
                          style: textTheme.headline6
                              ?.copyWith(color: colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: size.width * (92 / 254) * (135 / 92),
                    width: size.width,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(left: 19.0, right: 19.0),
                      scrollDirection: Axis.horizontal,
                      itemCount: vm.trainings.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 6, right: 6),
                          child: PreviewCard(
                            preview: vm.trainings[index]!.preview,
                            name: vm.trainings[index]!.title,
                            id: index,
                            onTapCard: (int index) {
                              pushNewScreen(
                                context,
                                screen:
                                    TrainingScreen(id: vm.trainings[index]!.id),
                                withNavBar: true,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class _ViewModel {
  final User? trainer;
  final User user;
  final Map<int, Training?> trainings;
  final Function(int, String) setDescription;
  final Function(File, int) setTrainerPicture;

  _ViewModel(
      {required this.trainer,
      required this.trainings,
      required this.user,
      required this.setDescription,
      required this.setTrainerPicture});

  static _ViewModel fromStore(Store<AppState> store, int id) {
    final Map<int, Training?> trainings = {};
    {
      // da ottimizzare (non ora)
      int index = 0;
      store.state.trainings.forEach((i, training) {
        if (store.state.trainers[id] != null &&
            training.trainerId == store.state.trainers[id]!.id) {
          trainings.addAll({index: training});
          index++;
        }
      });
    }
    return _ViewModel(
        setDescription: (int id, String text) =>
            store.dispatch(setTrainerDescription(id, text)),
        setTrainerPicture: (File fileToSave, int id) =>
            store.dispatch(setTrainerImage(fileToSave, id)),
        trainer: store.state.trainers[id],
        trainings: trainings,
        user: store.state.user);
  }
}
