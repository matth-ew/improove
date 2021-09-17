import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

Future<File?> showImagePickerCropper(
  BuildContext context, [
  int? maxHeight,
  int? maxWidth,
  String? cropper,
]) async {
  final colorScheme = Theme.of(context).colorScheme;
  // final buttonTheme = Theme.of(context).buttonTheme;
  // final textTheme = Theme.of(context).textTheme;
  final FilePickerResult? result =
      await FilePicker.platform.pickFiles(type: FileType.image);

  if (result != null && result.files.single.path != null) {
    CropStyle myCrop;
    (cropper == "circle")
        ? myCrop = CropStyle.circle
        : myCrop = CropStyle.rectangle;
    //final File file = File(result.files.single.path!);
    return ImageCropper.cropImage(
      sourcePath: result.files.single.path!,
      cropStyle: myCrop,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      androidUiSettings: AndroidUiSettings(
        // toolbarTitle: 'Cropper',
        toolbarColor: colorScheme.primary,
        toolbarWidgetColor: colorScheme.onPrimary,
        // activeControlsWidgetColor: colorScheme.primary,
        statusBarColor: colorScheme.primary,
        // initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: true,
        // hideBottomControls: true,
      ),
      // iosUiSettings: IOSUiSettings(
      //   minimumAspectRatio: 1.0,
      // ),
    );
  } else {
    // User canceled the picker
    return null;
  }
}
