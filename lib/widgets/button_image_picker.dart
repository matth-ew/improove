import 'dart:io';

import 'package:flutter/material.dart';
import 'package:improove/widgets/image_picker_cropper.dart';

class ButtonImagePicker extends StatelessWidget {
  final Function? callback;

  const ButtonImagePicker({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.black.withOpacity(0.1),
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(10),
      onPressed: () async {
        final File? fileToSave =
            await showImagePickerCropper(context, 500, 500, "rectangle");
        if (fileToSave != null) {
          await callback!(fileToSave);
        }
      },
      child: const Icon(Icons.photo_camera, color: Colors.white),
      // ),
      // child: Container(
      //   padding: EdgeInsets.symmetric(vertical: 5),
      //   decoration: BoxDecoration(
      //       // color: Colors.black.withOpacity(0.3),
      //       ),
      //   child: Icon(
      //     Icons.photo_camera,
      //     color: Colors.white,
      //     // color: Colors.white.withOpacity(0.5),
      //   ),
      // ),
    );
  }
}
