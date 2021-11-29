import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:improove/redux/models/local_video.dart';
import 'package:improove/widgets/trim_view.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

recordTrimVideo(BuildContext context, {Function? onSave}) async {
  try {
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
    // if (fileToSave != null) {
    //   vm.changeProfileImage(fileToSave, (String? e) {
    //     Navigator.pop(context);
    //   });
    // }
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
        maxHeight: 300,
        maxWidth:
            400, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 50,
      );
      thumbnailsTemp[elem.path] = _bytes;
    } catch (e) {
      debugPrint("ERR $e");
    }
  });

  return thumbnailsTemp;
}
