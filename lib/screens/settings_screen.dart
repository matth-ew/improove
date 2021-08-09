import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/redux/models/models.dart';
import 'package:redux/redux.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Settings"),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Photo'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.music_note),
                title: const Text('Music'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('Video'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text('Disconnect',
                    style: TextStyle(color: Colors.redAccent)),
                onTap: () {
                  vm.logout(() => {Navigator.pop(context)});
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ViewModel {
  final User user;
  final Function([Function? cb]) logout;

  _ViewModel({
    required this.user,
    required this.logout,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      user: store.state.user,
      logout: ([cb]) => store.dispatch(
        logoutThunk(cb),
      ),
    );
  }
}
