import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:improove/redux/actions/trainer.dart';
import 'package:improove/widgets/preview_card.dart';
import 'package:flutter_redux/flutter_redux.dart';
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return StoreConnector(
        converter: (Store<AppState> store) => _ViewModel.fromStore(store, id),
        onInit: (Store<AppState> store) {
          if (store.state.trainers[id] == null) {
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
                      if (vm.trainer != null &&
                          vm.trainer!.profileImage != null)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              vm.trainer!.profileImage!,
                            ),
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
                          '${vm.trainer?.name} ${vm.trainer?.surname}',
                          style: textTheme.headline4
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: ExpandableText(
                          vm.trainer?.trainerDescription ?? "",
                          expandText: "expand",
                          collapseText: "collapse",
                          linkColor: colorScheme.primary,
                          maxLines: 6,
                          style: textTheme.subtitle1?.copyWith(
                              color: colorScheme.primary.withOpacity(.59)),
                        ),
                      ),
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
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 6, right: 6),
                          child: PreviewCard(
                            preview: vm.trainer?.profileImage,
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

  _ViewModel({required this.trainer});

  static _ViewModel fromStore(Store<AppState> store, int id) {
    // if (store.state.trainers[id] == null) {
    //   store.dispatch(getTrainerById(id));
    // }
    // debugPrint(store.state.trainers[id]?.toString());
    return _ViewModel(trainer: store.state.trainers[id]);
  }
}
