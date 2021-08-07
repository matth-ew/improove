import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:improove/data.dart';
import 'package:improove/widgets/my_video_player.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/models/app_state.dart';
import 'package:improove/redux/models/models.dart';
import 'package:redux/redux.dart';

class ExerciseScreen extends StatelessWidget {
  final int training_id;
  final int id;
  const ExerciseScreen({Key? key, this.id = -1, this.training_id = -1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    String getVideo(String video) {
      if (video != "") {
        return video;
      } else {
        return "https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4"; //https: //assets.mixkit.co/videos/preview/mixkit-forest-stream-in-the-sunlight-529-large.mp4;
        ;
      }
    }

    return StoreConnector(
        converter: (Store<AppState> store) =>
            _ViewModel.fromStore(store, training_id, id),
        builder: (BuildContext context, _ViewModel vm) {
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  elevation: 0,
                  collapsedHeight: size.height * 0.38,
                  expandedHeight: size.height * 0.58,
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
                        bottom: 0,
                        left: 0,
                        right: 0,
                        top: 0,
                        child: Container(
                          color: Colors.black,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 35,
                        child:
                            MyVideoPlayer(video: getVideo(vm.exercise!.video)),
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
                        padding: const EdgeInsets.only(
                          left: 25.0,
                          right: 25.0,
                          bottom: 15.0,
                        ),
                        child: Text(
                          "How to Perform",
                          style: textTheme.headline6
                              ?.copyWith(color: colorScheme.primary),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 25.0,
                          right: 25.0,
                          bottom: 15.0,
                        ),
                        child: ExpandableText(
                          vm.exercise!.how,
                          expandText: "expand",
                          collapseText: "collapse",
                          linkColor: colorScheme.primary,
                          maxLines: 3,
                          style: textTheme.bodyText2?.copyWith(
                              color: colorScheme.primary.withOpacity(.59)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 25.0,
                          right: 25.0,
                          top: 0,
                          bottom: 10.0,
                        ),
                        child: Text(
                          "Common Mistakes",
                          style: textTheme.headline6
                              ?.copyWith(color: colorScheme.primary),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 25.0,
                          right: 25.0,
                          bottom: 15.0,
                        ),
                        child: ExpandableText(
                          vm.exercise!.mistakes,
                          expandText: "expand",
                          collapseText: "collapse",
                          linkColor: colorScheme.primary,
                          maxLines: 3,
                          style: textTheme.bodyText2?.copyWith(
                              color: colorScheme.primary.withOpacity(.59)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 25.0,
                          right: 25.0,
                          top: 0,
                          bottom: 10.0,
                        ),
                        child: Text(
                          "Tips",
                          style: textTheme.headline6
                              ?.copyWith(color: colorScheme.primary),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 25.0,
                          right: 25.0,
                          bottom: 5.0,
                        ),
                        child: ExpandableText(
                          vm.exercise!.tips,
                          expandText: "expand",
                          collapseText: "collapse",
                          linkColor: colorScheme.primary,
                          maxLines: 3,
                          style: textTheme.bodyText2?.copyWith(
                              color: colorScheme.primary.withOpacity(.59)),
                        ),
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

  _ViewModel({required this.exercise});

  static _ViewModel fromStore(Store<AppState> store, int training_id, int id) {
    return _ViewModel(
        exercise: store.state.trainings[training_id]!.exercises[id]);
  }
}
