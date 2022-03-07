import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:improove/redux/actions/local_video.dart';
import 'package:improove/redux/actions/video_folder.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/screens/local_video_screen.dart';
import 'package:improove/utility/video.dart';
import 'package:intl/intl.dart';
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
  Map<String, String?> printDates = {};

  Set<String> selected = {};

  Future<void> getThumbnails(List<LocalVideo> localVideos) async {
    Map<String, Uint8List?> thumbnailsTemp = {};
    Map<String, String?> printDatesTemp = {};

    String locale = Localizations.localeOf(context).languageCode;

    thumbnailsTemp = await generateThumbnail(localVideos);
    printDatesTemp = await generatePrintDate(localVideos, locale);

    setState(() {
      thumbnails = thumbnailsTemp;
      printDates = printDatesTemp;
    });
  }

  void _toggleSelected(String path) {
    setState(() {
      if (selected.contains(path)) {
        selected.remove(path);
      } else {
        selected.add(path);
      }
    });
  }

  Future<String?> _askFolder(List<VideoFolder> localFolders) {
    widget.videoFolder;
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.wantMoveVideo),
        content: SizedBox(
          // height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 0.6,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: localFolders.length,
              itemBuilder: (context, index) {
                String name = localFolders[index].name.isEmpty
                    ? "-"
                    : localFolders[index].name == "first-folder"
                        ? AppLocalizations.of(context)!.myWorkouts
                        : localFolders[index].name;
                return ListTile(
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text(name),
                  leading: const Icon(Icons.folder_rounded),
                  enabled:
                      localFolders[index].group != widget.videoFolder.group,
                  onTap: () {
                    Navigator.pop(context, localFolders[index].group);
                  },
                );
              }),
        ),
      ),
    );
  }

  Future<bool> _shouldPop() async {
    debugPrint("UE SHOULDPOP");
    if (selected.isEmpty) return Future.value(true);
    setState(() {
      selected = {};
    });
    return Future.value(false);
  }

  Future<bool?> _askDelete() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.wantDeleteVideo),
        // content: Text(AppLocalizations.of(context)!.allVideoLost),
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

  @override
  Widget build(BuildContext context) {
    // final Size size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    String name = widget.videoFolder.name == "first-folder"
        ? AppLocalizations.of(context)!.myWorkouts
        : widget.videoFolder.name;

    return WillPopScope(
      onWillPop: () async {
        debugPrint("UE SHO");
        return _shouldPop();
      },
      child: StoreConnector(
        onInitialBuild: (_ViewModel vm) => getThumbnails(vm.localVideos),
        onDidChange: (_ViewModel? _, _ViewModel vm) =>
            getThumbnails(vm.localVideos),
        converter: (Store<AppState> store) =>
            _ViewModel.fromStore(store, widget.videoFolder),
        builder: (BuildContext context, _ViewModel vm) {
          return WillPopScope(
            onWillPop: () async {
              debugPrint("UE SHO");
              return _shouldPop();
            },
            child: Scaffold(
              appBar: selected.isEmpty
                  ? AppBar(
                      iconTheme: IconThemeData(color: colorScheme.primary),
                      elevation: 1,
                      backgroundColor: colorScheme.background,
                      title: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: AppLocalizations.of(context)!.folderName,
                        ),
                        initialValue: name,
                        onFieldSubmitted: (String text) {
                          vm.changeFolderName(text);
                        },
                        style: textTheme.headline5?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600),
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
                                      content: Text(
                                          AppLocalizations.of(context)!
                                              .videoSavedSuccess),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          icon: Icon(Icons.video_call_rounded,
                              color: colorScheme.primary),
                        ),
                      ],
                    )
                  : AppBar(
                      iconTheme: IconThemeData(color: colorScheme.primary),
                      elevation: 1,
                      backgroundColor: colorScheme.background.withAlpha(220),
                      title: Text(
                        (selected.length).toString(),
                        style: textTheme.headline5?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      leading: IconButton(
                        splashRadius: 25,
                        onPressed: () {
                          setState(() {
                            selected = {};
                          });
                        },
                        icon: Icon(
                          Icons.close,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      actions: [
                        IconButton(
                          tooltip: AppLocalizations.of(context)!.shareFiles,
                          splashRadius: 25,
                          onPressed: () async {
                            shareVideos(selected.toList());
                            // final folderGroup = await _askFolder(vm.videoFolders);
                            // if (folderGroup != null && folderGroup.isNotEmpty) {
                            //   vm.moveLocalVideos(selected.toList(), folderGroup,
                            //       (String? e) {
                            //     setState(() {
                            //       selected = {};
                            //     });
                            //   });
                            // }
                          },
                          icon: Icon(
                            Icons.share_rounded,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        IconButton(
                          // tooltip: AppLocalizations.of(context)!.download,
                          splashRadius: 25,
                          onPressed: () async {
                            saveVideosToGallery(selected.toList(), (String? e) {
                              String text = '';
                              if (e == null) {
                                setState(() {
                                  selected = {};
                                });
                                text = AppLocalizations.of(context)!
                                    .videoSavedGallerySuccess;
                              } else {
                                text = 'Error';
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: colorScheme.primary,
                                  duration: const Duration(seconds: 3),
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(text),
                                ),
                              );
                            });
                          },
                          icon: Icon(
                            Icons.download_rounded,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        IconButton(
                          tooltip: AppLocalizations.of(context)!.changeFolder,
                          splashRadius: 25,
                          onPressed: () async {
                            final folderGroup =
                                await _askFolder(vm.videoFolders);
                            if (folderGroup != null && folderGroup.isNotEmpty) {
                              vm.moveLocalVideos(selected.toList(), folderGroup,
                                  (String? e) {
                                setState(() {
                                  selected = {};
                                });
                              });
                            }
                          },
                          icon: Icon(
                            Icons.drive_file_move,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        IconButton(
                          tooltip: AppLocalizations.of(context)!.delete,
                          splashRadius: 25,
                          onPressed: () async {
                            final delete = await _askDelete();
                            if (delete != null && delete) {
                              vm.deleteLocalVideos(selected.toList(),
                                  (String? e) {
                                setState(() {
                                  selected = {};
                                });
                              });
                            }
                          },
                          icon: Icon(
                            Icons.delete,
                            color: colorScheme.onSurface,
                          ),
                        )
                      ],
                    ),
              body: Visibility(
                visible: vm.localVideos.isNotEmpty,
                replacement: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/workout.svg',
                        width: 300,
                      ),
                      Text(
                        AppLocalizations.of(context)!.ctaRecordTrainings,
                        style: textTheme.subtitle2,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          recordTrimVideo(
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
                                      content: Text(
                                          AppLocalizations.of(context)!
                                              .videoSavedSuccess),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.video_call_rounded),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 8.0,
                              ),
                              child: Text(AppLocalizations.of(context)!.record),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          // minimumSize: const Size(300, 0),
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                child: GridView.builder(
                  padding: const EdgeInsets.only(top: 3),
                  scrollDirection: Axis.vertical,
                  itemCount: vm.localVideos.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    childAspectRatio: 0.6,
                  ),
                  itemBuilder: (context, index) {
                    String path = vm.localVideos[index].path;
                    Uint8List? thumbnail = thumbnails[path];
                    String printDate = printDates[path] ?? "";
                    return Ink(
                        key: Key(path),
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
                          child: Stack(
                            // mainAxisSize: MainAxisSize.max,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: selected.contains(path),
                                child: Container(
                                  color: Colors.black.withOpacity(0.4),
                                ),
                              ),
                              Visibility(
                                maintainSize: true,
                                maintainState: true,
                                maintainAnimation: true,
                                visible: selected.isNotEmpty,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: selected.contains(path)
                                      ? const Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                        )
                                      : const Icon(
                                          Icons.circle_outlined,
                                          color: Colors.white,
                                        ),
                                ),
                              ),
                              Container(
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
                                child: Text(
                                  printDate,
                                  style: textTheme.overline?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onLongPress: () async {
                            _toggleSelected(path);
                            // final delete = await _askDelete();
                            // if (delete != null && delete) {
                            //   vm.deleteLocalVideo(vm.localVideos[index].path);
                            // }
                          },
                          onTap: () {
                            if (selected.isNotEmpty) {
                              _toggleSelected(path);
                            } else {
                              pushNewScreen(
                                context,
                                screen: LocalVideoScreen(
                                  videos: vm.localVideos,
                                  // videos: vm.localVideos.where((element) => true),
                                  index: index,
                                  thumbnails: thumbnails,
                                ),
                                withNavBar: false,
                                pageTransitionAnimation: Platform.isIOS
                                    ? PageTransitionAnimation.cupertino
                                    : PageTransitionAnimation.fade,
                              );
                            }
                          },
                        ));
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ViewModel {
  final List<LocalVideo> localVideos;
  final List<VideoFolder> videoFolders;
  final Function(LocalVideo video, [Function? cb]) addLocalVideo;
  final Function(List<String> paths, String group, [Function? cb])
      moveLocalVideos;
  final Function(List<String> paths, [Function? cb]) deleteLocalVideos;
  final Function(String text, [Function? cb]) changeFolderName;

  _ViewModel({
    required this.localVideos,
    required this.videoFolders,
    required this.addLocalVideo,
    required this.moveLocalVideos,
    required this.deleteLocalVideos,
    required this.changeFolderName,
  });

  static _ViewModel fromStore(Store<AppState> store, VideoFolder folder) {
    return _ViewModel(
      localVideos: store.state.localVideos.reversed
          .where((v) => v.group == folder.group)
          .toList(),
      videoFolders: store.state.videoFolders,
      addLocalVideo: (video, [cb]) =>
          store.dispatch(addLocalVideoThunk(video, cb)),
      moveLocalVideos: (paths, group, [cb]) =>
          store.dispatch(moveLocalVideosThunk(paths, group, cb)),
      deleteLocalVideos: (paths, [cb]) =>
          store.dispatch(deleteLocalVideosThunk(paths, cb)),
      changeFolderName: (text, [cb]) =>
          store.dispatch(UpdateFolder(folder.copyWith(name: text))),
    );
  }
}
