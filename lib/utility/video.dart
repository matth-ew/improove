import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:improove/redux/models/local_video.dart';
// import 'package:improove/screens/camera_screen.dart';
import 'package:improove/widgets/trim_view.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gallery_saver/gallery_saver.dart';

recordTrimVideo(BuildContext context, {Function? onSave}) async {
  try {
    /*
    pushNewScreen(
      context,
      screen: CameraScreen(
        mode: CameraMode.video,
        onSave: (XFile fileToSave) {
          Navigator.of(context, rootNavigator: true).pushReplacement(
            getPageRoute(
              PageTransitionAnimation.cupertino,
              enterPage: TrimmerView(
                File(fileToSave.path),
                onSave: onSave,
              ),
            ),
          );
        },
      ),
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );*/
    /* */
    final ImagePicker _picker = ImagePicker();
    final XFile? fileToSave =
        await _picker.pickVideo(source: ImageSource.camera);
    if (fileToSave != null) {
      pushNewScreen(
        context,
        screen: TrimmerView(
          File(fileToSave.path),
          onSave: onSave,
        ),
        withNavBar: false,
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
    }
    /**/
  } catch (e) {
    debugPrint("Errore in selezione immagine ${e.toString()}");
  }
}

Future<Map<String, Uint8List?>> generateThumbnail(
    List<LocalVideo> localVideos) async {
  // if (localVideos == null || localVideos.isEmpty) return;
  Map<String, Uint8List?> thumbnailsTemp = {};
  await Future.forEach(localVideos, (LocalVideo elem) async {
    try {
      Uint8List? _bytes = await VideoThumbnail.thumbnailData(
        video: elem.path,
        imageFormat: ImageFormat.WEBP,
        maxHeight: 600,
        maxWidth:
            800, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 50,
      );
      thumbnailsTemp[elem.path] = _bytes;
    } catch (e) {
      debugPrint("ERR $e");
    }
  });

  return thumbnailsTemp;
}

Future<Map<String, String?>> generatePrintDate(
    List<LocalVideo> localVideos, String locale) async {
  // if (localVideos == null || localVideos.isEmpty) return;
  Map<String, String?> printDatesTemp = {};
  await Future.forEach(localVideos, (LocalVideo elem) async {
    try {
      DateTime date;
      String printDate = '';
      bool v = await File(elem.path).exists();
      if (v) {
        date = File(elem.path).lastModifiedSync();
        printDate = DateFormat.yMd(locale).format(date);
      }
      printDatesTemp[elem.path] = printDate;
    } catch (e) {
      debugPrint("ERR $e");
    }
  });

  return printDatesTemp;
}

shareVideos(List<String> videos) {
  Share.shareFiles(videos);
}

saveVideosToGallery(List<String> videos, [Function? cb]) async {
  Future.forEach(videos, (String path) async {
    try {
      await GallerySaver.saveVideo(path, albumName: 'Improove');
    } catch (e) {
      debugPrint("ERR $e");
    }
  }).then((v) => cb?.call(null)).catchError((error) => cb?.call(error));
}
