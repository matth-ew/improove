import 'package:flutter/material.dart';

class FormFieldHolder {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  Widget builder(remove, context) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: remove,
          icon: const Icon(Icons.cancel),
          splashRadius: 24,
          padding: EdgeInsets.zero,
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
        // labelText: 'Email',
      ),
    );
  }

  dispose() {
    controller.dispose();
    focusNode.dispose();
  }
}
