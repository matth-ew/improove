import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/screens/authentication_screen.dart';
import 'package:improove/screens/webview_screen.dart';
import 'package:improove/widgets/image_picker_cropper.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

import 'settings_widgets/change_personal_info.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String currentText = "";

  Future<void> _submit(Function thunkAction, String? value) async {
    try {
      thunkAction(
        value,
        (String? e) {
          if (e == null) {
            debugPrint("NOT ERROR");
            Navigator.of(context).pop();
            snackBar("Thanks for your help");
          } else {
            debugPrint("ERROR ${e.toString()}");
          }
        },
      );
      // .then((val) {
      //   final String? token = val?.data['token'] as String?;
      //   final String? msg = val?.data['msg'] as String?;
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Processing Data Facebook: $msg - $token'),
      //     ),
      //   );
      // });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  snackBar(String? message) {
    final colorScheme = Theme.of(context).colorScheme;
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        backgroundColor: colorScheme.secondary,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // final buttonTheme = Theme.of(context).buttonTheme;
    final textTheme = Theme.of(context).textTheme;
    return StoreConnector(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Tell us what you think",
                style: textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.w600, color: colorScheme.primary),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      currentText = value;
                    });
                  },
                  maxLines: 5,
                  minLines: 5,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _submit(vm.sendFeedback, currentText);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 50),
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ViewModel {
  final Function(String text, [Function? cb]) sendFeedback;

  _ViewModel({
    required this.sendFeedback,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      sendFeedback: (text, [cb]) => store.dispatch(
        sendFeedbackThunk(text, cb),
      ),
    );
  }
}
