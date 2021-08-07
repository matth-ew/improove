import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:improove/redux/actions/training.dart';
import 'package:improove/widgets/preview_card.dart';
import 'package:improove/screens/exercise_screen.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/models/app_state.dart';
import 'package:improove/redux/models/models.dart';
import 'package:redux/redux.dart';

class TrainingScreen extends StatelessWidget {
  final int id;
  const TrainingScreen({
    Key? key,
    this.id = -1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return StoreConnector(
        converter: (Store<AppState> store) => _ViewModel.fromStore(store, id),
        onInit: (store) {
          //store.dispatch(getTrainingById(id));
        },
        builder: (BuildContext context, _ViewModel vm) {
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  elevation: 0,
                  expandedHeight: size.height * 0.45,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    iconSize: 32,
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  flexibleSpace: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Image(
                          fit: BoxFit.cover,
                          image: NetworkImage(vm.training!.preview),
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
                            onTap: () => {},
                            child: FadeInImage(
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                placeholder: const AssetImage(
                                    "assets/images/trainer_avatar.jpg"),
                                image: NetworkImage(vm.training!.trainerImage)),
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
                        child: ExpandableText(
                          vm.training!.description,
                          expandText: "expand",
                          collapseText: "collapse",
                          linkColor: colorScheme.primary,
                          maxLines: 3,
                          style: textTheme.subtitle1?.copyWith(
                              color: colorScheme.primary.withOpacity(.59)),
                        ),
                      ),
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
                            avatar: vm.training!.trainerImage,
                            id: index,
                            onTapCard: (int index) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ExerciseScreen(
                                        training_id: id, id: index)),
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
  final Training? training;

  _ViewModel({required this.training});

  static _ViewModel fromStore(Store<AppState> store, int id) {
    if (store.state.trainings[id]!.description == "") {
      store.dispatch(getTrainingById(id));
    }
    debugPrint(store.state.trainings[id]!.exercises.toString());
    return _ViewModel(training: store.state.trainings[id]);
  }
}
