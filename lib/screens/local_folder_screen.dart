import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/actions/local_video.dart';
import 'package:improove/redux/models/local_video.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/screens/local_video_screen.dart';
import 'package:improove/utility/video.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocalFolderScreen extends StatefulWidget {
  final VideoFolder videoFolder;
  const LocalFolderScreen({
    Key? key,
    required this.videoFolder,
  }) : super(key: key);

  @override
  State<LocalFolderScreen> createState() => _LocalFolderScreenState();
}

class _LocalFolderScreenState extends State<LocalFolderScreen> {
  Map<String, Uint8List?> thumbnails = {};

  Future<void> getThumbnails(List<LocalVideo> localVideos) async {
    Map<String, Uint8List?> thumbnailsTemp = {};
    thumbnailsTemp = await generateThumbnail(localVideos);

    setState(() {
      thumbnails = thumbnailsTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final Size size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return StoreConnector(
      onInitialBuild: (_ViewModel vm) => getThumbnails(vm.localVideos),
      onDidChange: (_ViewModel? _, _ViewModel vm) =>
          getThumbnails(vm.localVideos),
      converter: (Store<AppState> store) =>
          _ViewModel.fromStore(store, widget.videoFolder.group),
      builder: (BuildContext context, _ViewModel vm) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: colorScheme.primary),
            elevation: 0,
            title: Text(
              // vm.user.name.isNotEmpty
              //     ? "${vm.user.name} ${vm.user.surname}" :
              widget.videoFolder.name,
              style: textTheme.headline5?.copyWith(
                  color: colorScheme.primary, fontWeight: FontWeight.w600),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: Colors.grey.shade300,
                height: 1.0,
              ),
            ),
            actions: [
              IconButton(
                splashRadius: 25,
                onPressed: () => recordTrimVideo(
                  context,
                  onSave: (String path) async {
                    vm.addLocalVideo(
                      LocalVideo(
                        path: path,
                        group: widget.videoFolder.group,
                      ),
                      (String? e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: colorScheme.primary,
                            duration: const Duration(seconds: 3),
                            behavior: SnackBarBehavior.floating,
                            content: Text(AppLocalizations.of(context)!
                                .videoSavedSuccess),
                          ),
                        );
                      },
                    );
                  },
                ),
                icon:
                    Icon(Icons.video_call_rounded, color: colorScheme.primary),
              ),
            ],
            backgroundColor: colorScheme.background,
          ),
          body: GridView.builder(
            scrollDirection: Axis.vertical,
            itemCount: vm.localVideos.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              childAspectRatio: 0.6,
            ),
            itemBuilder: (context, index) {
              Uint8List? thumbnail = thumbnails[vm.localVideos[index].path];
              return Ink(
                  key: UniqueKey(),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    image: thumbnail != null
                        ? DecorationImage(
                            image: MemoryImage(thumbnail),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: InkWell(
                    focusColor: Colors.red.withOpacity(0.0),
                    highlightColor: Colors.black.withOpacity(0.25),
                    splashColor: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.8, 0.9, 1],
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.3)
                          ],
                        ),
                      ),
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(8.0),
                      //TODO: Caricare data dei file
                      child: Text("12/12/2021",
                          style: textTheme.overline
                              ?.copyWith(color: Colors.white)),
                    ),
                    onTap: () {
                      pushNewScreen(
                        context,
                        screen: Scaffold(
                          backgroundColor: Colors.black,
                          body: LocalVideoScreen(
                            videos: vm.localVideos,
                            // videos: vm.localVideos.where((element) => true),
                            index: index,
                            thumbnails: thumbnails,
                          ),
                        ),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                  ));
            },
          ),
        );
      },
    );
  }
}

class _ViewModel {
  final List<LocalVideo> localVideos;
  final Function(LocalVideo video, [Function? cb]) addLocalVideo;

  _ViewModel({
    required this.localVideos,
    required this.addLocalVideo,
  });

  static _ViewModel fromStore(Store<AppState> store, String group) {
    return _ViewModel(
      localVideos: store.state.localVideos.reversed
          .where((v) => v.group == group)
          .toList(),
      addLocalVideo: (video, [cb]) =>
          store.dispatch(addLocalVideoThunk(video, cb)),
    );
  }
}
