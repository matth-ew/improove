import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/screens/authentication_screen.dart';
import 'package:improove/widgets/image_picker_cropper.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';

class SettingsScreen extends StatelessWidget {
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
                final File? fileToSave =
                    await showImagePickerCropper(context, 500, 500, "circle");
                if (fileToSave != null) {
                  vm.changeProfileImage(fileToSave, () {
                    Navigator.pop(context);
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Change Personal Info'),
              onTap: () {
                pushNewScreen(
                  context,
                  screen: ChangePersonalInfo(),
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
                              AuthenticationScreen()),
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

  _ViewModel({
    required this.user,
    required this.logout,
    required this.changeProfileImage,
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
    );
  }
}

class ChangePersonalInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // final buttonTheme = Theme.of(context).buttonTheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Change personal info",
          style: textTheme.headline6?.copyWith(
              color: colorScheme.primary, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          splashRadius: 25,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close, color: colorScheme.onSurface),
        ),
        actions: [
          IconButton(
            splashRadius: 25,
            onPressed: () {},
            icon: Icon(Icons.done, color: colorScheme.secondary),
          ),
        ],
        backgroundColor: colorScheme.background,
      ),
      body: Form(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: TextFormField(
                // key: _formEmailKey,
                // controller: _emailController,
                onFieldSubmitted: (value) {
                  // _formEmailKey.currentState?.validate();
                },
                keyboardType: TextInputType.emailAddress,
                // validator: validateEmail,
                decoration: InputDecoration(
                  errorMaxLines: 2,
                  contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  labelText: 'Email',
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: TextFormField(
                // key: _formEmailKey,
                // controller: _emailController,
                onFieldSubmitted: (value) {
                  // _formEmailKey.currentState?.validate();
                },
                keyboardType: TextInputType.emailAddress,
                // validator: validateEmail,
                decoration: InputDecoration(
                  errorMaxLines: 2,
                  contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  labelText: 'Email',
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: TextFormField(
                // key: _formEmailKey,
                // controller: _emailController,
                onFieldSubmitted: (value) {
                  // _formEmailKey.currentState?.validate();
                },
                keyboardType: TextInputType.emailAddress,
                // validator: validateEmail,
                decoration: InputDecoration(
                  errorMaxLines: 2,
                  contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  labelText: 'Email',
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
