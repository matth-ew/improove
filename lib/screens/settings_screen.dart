import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/screens/authentication_screen.dart';
// import 'package:improove/screens/payment_screen.dart';
import 'package:improove/screens/webview_screen.dart';
// import 'package:improove/screens/sub_plans_screen.dart';
import 'package:improove/widgets/image_picker_cropper.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'settings_widgets/change_personal_info.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
              title: Text(AppLocalizations.of(context)!.changeProfImage),
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
            // ListTile(
            //   leading: const Icon(Icons.video_camera_front_rounded),
            //   title: const Text('Take a video'),
            //   onTap: () => recordTrimVideo(
            //     context,
            //     onSave: (String path) async {
            //       vm.addLocalVideo(
            //         LocalVideo(path: path, group: ""),
            //       );
            //     },
            //   ),
            // ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(AppLocalizations.of(context)!.changePersInfo),
              onTap: () {
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
              title: Text(AppLocalizations.of(context)!.termsConditions),
              onTap: () {
                pushNewScreen(
                  context,
                  screen:
                      const WebViewScreen(url: "https://improove.fit/terms"),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: Text(AppLocalizations.of(context)!.privacyPolicy),
              onTap: () {
                pushNewScreen(
                  context,
                  screen:
                      const WebViewScreen(url: "https://improove.fit/privacy"),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(AppLocalizations.of(context)!.contactUs),
              onTap: () {
                String? encodeQueryParameters(Map<String, String> params) {
                  return params.entries
                      .map((e) =>
                          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                      .join('&');
                }

                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'info@improove.fit',
                  query: encodeQueryParameters(<String, String>{
                    'subject': 'Example Subject & Symbols are allowed!'
                  }),
                );

                launch(emailLaunchUri.toString());
              },
            ),
            Visibility(
              visible: vm.user.subscribed,
              child: ListTile(
                leading: const Icon(Icons.payments),
                title: Text(AppLocalizations.of(context)!.handleSubscription),
                // title: Text(AppLocalizations.of(context)!.termsConditions),
                onTap: () {
                  String url = "";
                  if (Platform.isIOS) {
                    url = "https://apps.apple.com/account/subscriptions";
                  } else {
                    url =
                        "https://play.google.com/store/account/subscriptions?&package=fit.improove.app";
                  }
                  launch(url);
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: colorScheme.error),
              title: Text(AppLocalizations.of(context)!.disconnect,
                  style: TextStyle(color: colorScheme.error)),
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
  final Function(LocalVideo video, [Function? cb]) addLocalVideo;

  _ViewModel({
    required this.user,
    required this.logout,
    required this.changeProfileImage,
    required this.changeProfileInfo,
    required this.addLocalVideo,
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
        addLocalVideo: (video, [cb]) =>
            store.dispatch(addLocalVideoThunk(video, cb)));
  }
}
