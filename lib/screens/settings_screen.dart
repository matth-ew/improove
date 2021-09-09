import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/screens/authentication_screen.dart';
import 'package:improove/screens/privacy_screen.dart';
import 'package:improove/screens/terms_screen.dart';
import 'package:improove/widgets/image_picker_cropper.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';

import 'settings_widgets/change_personal_info.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;
    // final buttonTheme = Theme.of(context).buttonTheme;
    // final textTheme = Theme.of(context).textTheme;
    return StoreConnector(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Change Profile Image'),
              onTap: () async {
                try {
                  final File? fileToSave =
                      await showImagePickerCropper(context, 500, 500, "circle");
                  if (fileToSave != null) {
                    vm.changeProfileImage(fileToSave, (String? e) {
                      Navigator.pop(context);
                    });
                  }
                } catch (e) {
                  debugPrint("Errore in selezione immagine ${e.toString()}");
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Change Personal Info'),
              onTap: () {
                // showDialog(
                //   context: context,
                //   builder: (BuildContext context) {
                //     return SimpleDialog(
                //       title: Text("Change personal info"),
                //       children: [
                //         ChangePersonalInfo(),
                //       ],
                //     );
                //   },
                // );
                pushNewScreen(
                  context,
                  screen: ChangePersonalInfo(
                    name: vm.user.name,
                    surname: vm.user.surname,
                    submit: vm.changeProfileInfo,
                  ),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Terms & Conditions'),
              onTap: () {
                pushNewScreen(
                  context,
                  screen: const TermsScreen(),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Privacy Policy'),
              onTap: () {
                pushNewScreen(
                  context,
                  screen: const PrivacyScreen(),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Disconnect',
                  style: TextStyle(color: Colors.redAccent)),
              onTap: () {
                vm.logout(
                  (String? e) {
                    Navigator.of(context).pushAndRemoveUntil<void>(
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const AuthenticationScreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _ViewModel {
  final User user;
  final Function([Function? cb]) logout;
  final Function(File image, [Function? cb]) changeProfileImage;
  final Function(String name, String surname, [Function? cb]) changeProfileInfo;

  _ViewModel({
    required this.user,
    required this.logout,
    required this.changeProfileImage,
    required this.changeProfileInfo,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      user: store.state.user,
      logout: ([cb]) => store.dispatch(
        logoutThunk(cb),
      ),
      changeProfileImage: (image, [cb]) => store.dispatch(
        changeProfileImageThunk(image, cb),
      ),
      changeProfileInfo: (name, surname, [cb]) => store.dispatch(
        changeProfileInfoThunk(name, surname, cb),
      ),
    );
  }
}
