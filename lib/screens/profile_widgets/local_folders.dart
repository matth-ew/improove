import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/actions/local_video.dart';
import 'package:improove/redux/actions/video_folder.dart';
import 'package:improove/redux/models/app_state.dart';
import 'package:improove/redux/models/local_video.dart';
import 'package:improove/redux/models/video_folder.dart';
import 'package:improove/screens/local_folder_screen.dart';
import 'package:improove/utility/video.dart';
import 'package:improove/widgets/custom_bottom_sheet.dart';
import 'package:improove/widgets/row_card.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'folder_name_dialog.dart';

class LocalFolders extends StatefulWidget {
  const LocalFolders({Key? key}) : super(key: key);

  @override
  State<LocalFolders> createState() => _LocalFoldersState();
}

class _LocalFoldersState extends State<LocalFolders> {
  Map<String, Uint8List?> thumbnails = {};

  Future<void> getThumbnails(
    List<LocalVideo> localVideos,
    List<VideoFolder> videoFolders,
  ) async {
    // debugPrint("FOLDERS ${videoFolders.map((x) => x.name)}");
    Map<String, Uint8List?> thumbnailsTemp = {};
    List<LocalVideo> videoToLoad = [];
    for (var f in videoFolders) {
      try {
        videoToLoad.add(localVideos.lastWhere((v) => v.group == f.group));
      } catch (e) {
        debugPrint("folder with no video");
      }
    }
    thumbnailsTemp = await generateThumbnail(videoToLoad);

    setState(() {
      thumbnails = thumbnailsTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;
    // final textTheme = Theme.of(context).textTheme;
    // final Size size = MediaQuery.of(context).size;
    return StoreConnector(
      onInitialBuild: (_ViewModel vm) =>
          getThumbnails(vm.localVideos, vm.videoFolders),
      onDidChange: (_ViewModel? _, _ViewModel vm) =>
          getThumbnails(vm.localVideos, vm.videoFolders),
      converter: (Store<AppState> store) =>
          _ViewModel.fromStore(store, context),
      builder: (BuildContext context, _ViewModel vm) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: vm.videoFolders.length,
                itemBuilder: (context, index) {
                  VideoFolder videoFolder = vm.videoFolders[index];
                  String name = videoFolder.name.isEmpty
                      ? "-"
                      : videoFolder.name == "first-folder"
                          ? AppLocalizations.of(context)!.myWorkouts
                          : videoFolder.name;
                  List<LocalVideo> videos = vm.localVideos
                      .where((v) => v.group == videoFolder.group)
                      .toList();
                  Uint8List? thumbnail;
                  if (videos.isNotEmpty) {
                    thumbnail = thumbnails[videos.last.path];
                  }
                  return RowCard(
                    name: name,
                    category:
                        "${videos.length} ${AppLocalizations.of(context)!.video}",
                    actions: [
                      PopupMenuButton(
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem(
                              child: Text(AppLocalizations.of(context)!.record),
                              onTap: () {
                                recordTrimVideo(
                                  context,
                                  onSave: (String path) async {
                                    vm.addLocalVideo(
                                      LocalVideo(
                                        path: path,
                                        group: videoFolder.group,
                                      ),
                                      (String e) {
                                        pushNewScreen(
                                          context,
                                          screen: Scaffold(
                                            backgroundColor: Colors.black,
                                            body: LocalFolderScreen(
                                                videoFolder: videoFolder),
                                          ),
                                          withNavBar: true,
                                          pageTransitionAnimation:
                                              PageTransitionAnimation.fade,
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                            PopupMenuItem(
                              child: Text(AppLocalizations.of(context)!.delete),
                              onTap: () async {
                                final delete = await _askDelete(videos.length);
                                if (delete != null && delete) {
                                  vm.deleteVideoFolder(videoFolder.group);
                                }
                              },
                            ),
                          ];
                        },
                        child: const Icon(
                          Icons.more_vert,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                      // IconButton(
                      //   onPressed: () => recordTrimVideo(
                      //     context,
                      //     onSave: (String path) async {
                      //       vm.addLocalVideo(
                      //         LocalVideo(path: path, group: videoFolder.group),
                      //         (String e) {
                      //           pushNewScreen(
                      //             context,
                      //             screen: Scaffold(
                      //               backgroundColor: Colors.black,
                      //               body: LocalFolderScreen(
                      //                   videoFolder: videoFolder),
                      //             ),
                      //             withNavBar: true,
                      //             pageTransitionAnimation:
                      //                 PageTransitionAnimation.fade,
                      //           );
                      //         },
                      //       );
                      //     },
                      //   ),
                      //   icon: Icon(Icons.video_call_rounded,
                      //       color: colorScheme.primary),
                      // ),
                    ],
                    preview: thumbnail,
                    onTap: () {
                      pushNewScreen(
                        context,
                        screen: Scaffold(
                          backgroundColor: Colors.black,
                          body: LocalFolderScreen(videoFolder: videoFolder),
                        ),
                        withNavBar: true,
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                child: Text(AppLocalizations.of(context)!.createFolder),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  showCustomBottomSheet(
                    context,
                    FolderNameDialog(
                      onSubmit: (String name, Function? cb) {
                        var uuid = const Uuid();
                        vm.addVideoFolder(
                          VideoFolder(
                            group: "folder${uuid.v1()}",
                            name: name,
                          ),
                          cb,
                        );
                      },
                    ),
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }

  Future<bool?> _askDelete(int numVideos) {
    if (numVideos == 0) return Future.value(true);
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.wantDeleteFolder),
        content: Text(AppLocalizations.of(context)!.allVideoLost),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context)!.no),
            onPressed: () {
              Navigator.pop(context, false);
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
              Navigator.pop(context, true);
            },
          )
        ],
      ),
    );
  }
}

class _ViewModel {
  final List<LocalVideo> localVideos;
  final List<VideoFolder> videoFolders;
  final Function(VideoFolder folder, [Function? cb]) addVideoFolder;
  final Function(String group, [Function? cb]) deleteVideoFolder;
  final Function(LocalVideo video, [Function? cb]) addLocalVideo;

  _ViewModel({
    required this.localVideos,
    required this.videoFolders,
    required this.addVideoFolder,
    required this.deleteVideoFolder,
    required this.addLocalVideo,
  });

  static _ViewModel fromStore(Store<AppState> store, BuildContext context) {
    // List<VideoFolder> tempFolder = List.from(store.state.videoFolders);
    // tempFolder.add(VideoFolder(
    //     name: AppLocalizations.of(context)!.notAssigned, group: ""));
    return _ViewModel(
      localVideos: store.state.localVideos,
      videoFolders: store.state.videoFolders,
      // videoFolders: store.state.localVideos.map((v) => v.group).toSet().toList(),
      addVideoFolder: (folder, [cb]) =>
          store.dispatch(addVideoFolderThunk(folder, cb)),
      deleteVideoFolder: (group, [cb]) =>
          store.dispatch(deleteVideoFolderThunk(group, cb)),
      addLocalVideo: (video, [cb]) =>
          store.dispatch(addLocalVideoThunk(video, cb)),
    );
  }
}
