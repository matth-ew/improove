import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:improove/widgets/my_video_player.dart';
import 'package:improove/widgets/row_card.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalVideo extends StatefulWidget {
  const LocalVideo({Key? key}) : super(key: key);

  @override
  State<LocalVideo> createState() => _LocalVideoState();
}

class _LocalVideoState extends State<LocalVideo> {
  // Future<String?>? _tempDirectory;
  // Future<List<File>?>? _videoFiles;
  // @override
  // void initState() {
  //   _loadPath();
  //   super.initState();
  // }
  List<File> video = [];
  List<Uint8List?> thumbnails = [];
  @override
  void initState() {
    generateThumbnail();
    super.initState();
  }
  // Future<List<Uint8List?>>? videoThumbnails;

  Future<void> generateThumbnail() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    List<Uint8List?> unit8List = [];
    await appDocDir
        .list(recursive: true, followLinks: true)
        .forEach((elem) async {
      if (elem.path.endsWith(".mp4")) {
        try {
          Uint8List? _bytes = await VideoThumbnail.thumbnailData(
            video: elem.path,
            imageFormat: ImageFormat.WEBP,
            maxHeight: 300,
            maxWidth:
                400, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
            quality: 50,
          );
          setState(() {
            video.add(elem as File);
            thumbnails.add(_bytes);
          });
        } catch (e) {
          debugPrint("ERR $e");
        }
      }
    }).then((x) {
      return Future.value(unit8List);
    });
    // setState(() {
    //   videoThumbnails = Future.value(unit8List);
    // });

    // return Future.value(unit8List);
  }

  // Future<List<File>> _loadPath() async {
  //   Directory appDocDir = await getApplicationDocumentsDirectory();
  //   // debugPrint("UE LOADPATH ${appDocDir.list()}");
  //   List<File> fileList = [];
  //   appDocDir.list(recursive: true, followLinks: true).forEach((elem) async {
  //     if (elem.path.endsWith(".mp4")) {
  //       fileList.add(elem as File);
  //     }
  //   });
  //   return fileList;
  //   // setState(() {
  //   //   _tempDirectory = Future.value(appDocDir.path);
  //   //   _videoFiles = Future.value(fileList);
  //   // });
  //   // return Future.value(appDocDir.path);
  // }
  // VideoPlayerController? _controller;
  // @override
  // void initState() {
  //   super.initState();
  //   _controller = VideoPlayerController.file(File(
  //       "/data/user/0/fit.improove.app/app_flutter/VideoSalvati/VideoDiProva1.mp4"))
  //     ..initialize().then((_) {
  //       // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
  //       setState(() {});
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final Size size = MediaQuery.of(context).size;
    // if (_controller != null && _controller!.value.isInitialized) {
    //   return VideoPlayer(_controller!);
    // } else
    //   return Container();
    // return FutureBuilder<void>(
    //     future: generateThumbnail(),
    //     builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: thumbnails.length,
      itemBuilder: (context, index) {
        return CardRow(
          name: "Nome Esercizio",
          category: "",
          preview: thumbnails[index]!,
          onTap: () {
            pushNewScreen(
              context,
              screen: Scaffold(
                backgroundColor: Colors.black,
                body: MyVideoPlayer(
                  video: video[index],
                ),
              ),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
        );

        Padding(
          padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: size.width * 0.28,
                child: AspectRatio(
                  aspectRatio: 1.54,
                  child: Image(
                    image: MemoryImage(thumbnails[index]!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    // });
    // FutureBuilder<List<Uint8List?>>(
    //   // future: generateThumbnail(),
    //   builder:
    //       (BuildContext context, AsyncSnapshot<List<Uint8List?>> snapshot) {
    //     // if (snapshot.hasData) {
    //     //   List<Uint8List?> _imageBytes = snapshot.data!;
    //     //   debugPrint("UEUE ${_imageBytes.length}");
    //     //   return ListView.builder(
    //     //     scrollDirection: Axis.vertical,
    //     //     itemCount: _imageBytes.length,
    //     //     itemBuilder: (context, index) {
    //     //       return SizedBox(
    //     //         height: 150,
    //     //         width: 300,
    //     //         child: Image(
    //     //           image: MemoryImage(_imageBytes[index]!),
    //     //           fit: BoxFit.cover,
    //     //         ),
    //     //       );
    //     //     },
    //     //   );
    //     // } else {
    //     //   return Container(color: Colors.amber);
    //     // }
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.waiting:
    //         return Text('Loading....');
    //       default:
    //         if (snapshot.hasError)
    //           return Text('Error: ${snapshot.error}');
    //         else {
    //           List<Uint8List?> _imageBytes = snapshot.data!;
    //           debugPrint("UEUE ${snapshot}");
    //           return ListView.builder(
    //             scrollDirection: Axis.vertical,
    //             itemCount: _imageBytes.length,
    //             itemBuilder: (context, index) {
    //               return SizedBox(
    //                 height: 150,
    //                 width: 300,
    //                 child: Image(
    //                   image: MemoryImage(_imageBytes[index]!),
    //                   fit: BoxFit.cover,
    //                 ),
    //               );
    //             },
    //           );
    //         }
    //     }
    //   },
    // );
  }
}
