import 'dart:io';

import 'package:flutter/material.dart';
import 'package:improove/widgets/image_picker_cropper.dart';

class ButtonImagePicker extends StatelessWidget {
  final int width = 0;
  final int height = 0;
  final Function? callback;

  const ButtonImagePicker({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          final File? fileToSave =
              await showImagePickerCropper(context, 500, 500, "rectangle");
          if (fileToSave != null) {
            await callback!(fileToSave);
            Navigator.pop(context);
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
          ),
          child: Icon(
            Icons.photo_camera,
            color: Colors.white.withOpacity(0.5),
          ),
        ));
  }
}
