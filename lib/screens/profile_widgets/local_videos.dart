import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/actions/local_video.dart';
import 'package:improove/redux/models/app_state.dart';
import 'package:improove/redux/models/local_video.dart';
import 'package:improove/screens/local_video_screen.dart';
import 'package:improove/widgets/row_card.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class LocalVideos extends StatefulWidget {
  const LocalVideos({Key? key}) : super(key: key);

  @override
  State<LocalVideos> createState() => _LocalVideosState();
}

class _LocalVideosState extends State<LocalVideos> {
  // Future<String?>? _tempDirectory;
  // Future<List<File>?>? _videoFiles;
  // @override
  // void initState() {
  //   _loadPath();
  //   super.initState();
  // }
  // List<LocalVideo> videoList = [];
  // List<File> video = [];
  List<Uint8List?> thumbnails = [];
  // @override
  // void initState() {
  //   generateThumbnail();
  //   super.initState();
  // }

  // @override
  // bool get wantKeepAlive => true;
  // // Future<List<Uint8List?>>? videoThumbnails;

  Future<void> generateThumbnail(List<LocalVideo> localVideos) async {
    // if (localVideos == null || localVideos.isEmpty) return;
    List<Uint8List?> thumbnailsTemp = [];
    await Future.forEach(localVideos, (LocalVideo elem) async {
      try {
        Uint8List? _bytes = await VideoThumbnail.thumbnailData(
          video: elem.path,
          imageFormat: ImageFormat.WEBP,
          maxHeight: 300,
          maxWidth:
              400, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
          quality: 50,
        );
        thumbnailsTemp.add(_bytes);
      } catch (e) {
        debugPrint("ERR $e");
      }
    });

    setState(() {
      // video.add(File(elem.path));
      thumbnails = thumbnailsTemp;
    });

    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // List<Uint8List?> unit8List = [];
    // await appDocDir
    //     .list(recursive: true, followLinks: true)
    //     .forEach((elem) async {
    //   if (elem.path.endsWith(".mp4")) {
    //     try {
    //       Uint8List? _bytes = await VideoThumbnail.thumbnailData(
    //         video: elem.path,
    //         imageFormat: ImageFormat.WEBP,
    //         maxHeight: 300,
    //         maxWidth:
    //             400, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
    //         quality: 50,
    //       );
    //       setState(() {
    //         video.add(elem as File);
    //         thumbnails.add(_bytes);
    //       });
    //     } catch (e) {
    //       debugPrint("ERR $e");
    //     }
    //   }
    // }).then((x) {
    //   return Future.value(unit8List);
    // });
    // setState(() {
    //   videoThumbnails = Future.value(unit8List);
    // });

    // return Future.value(unit8List);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final Size size = MediaQuery.of(context).size;
    return StoreConnector(
      onInitialBuild: (_ViewModel vm) => generateThumbnail(vm.localVideos),
      onDidChange: (_ViewModel? _, _ViewModel vm) =>
          generateThumbnail(vm.localVideos),
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {
        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: vm.localVideos.length,
          itemBuilder: (context, index) {
            return CardRow(
              name: "Nome Esercizio",
              category: "",
              preview: thumbnails.length > index ? thumbnails[index] : null,
              onTap: () {
                pushNewScreen(
                  context,
                  screen: Scaffold(
                    backgroundColor: Colors.black,
                    body: LocalVideoScreen(
                      video: File(vm.localVideos[index].path),
                      thumbnails: thumbnails,
                    ),
                  ),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
            );
          },
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

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      localVideos: store.state.localVideos,
      addLocalVideo: (video, [cb]) =>
          store.dispatch(addLocalVideoThunk(video, cb)),
    );
  }
}
