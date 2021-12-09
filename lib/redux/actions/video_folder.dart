import 'package:flutter/material.dart';
import 'package:improove/redux/actions/local_video.dart';
import 'package:improove/redux/models/models.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class AddVideoFolder {
  final VideoFolder folder;

  AddVideoFolder(this.folder);
}

class DeleteVideoFolder {
  final String group;

  DeleteVideoFolder(this.group);
}

class UpdateFolder {
  final VideoFolder updatedFolder;

  UpdateFolder(this.updatedFolder);
}

ThunkAction<AppState> addVideoFolderThunk(VideoFolder folder, [Function? cb]) {
  return (Store<AppState> store) async {
    try {
      debugPrint("ADDING FOLDER ${folder.name} ${folder.group}");
      store.dispatch(AddVideoFolder(folder));
      cb?.call(null);
    } catch (e) {
      cb?.call(e.toString());
    }
  };
}

ThunkAction<AppState> deleteVideoFolderThunk(String group, [Function? cb]) {
  return (Store<AppState> store) async {
    try {
      debugPrint("REMOVING FOLDER $group");
      await store.dispatch(deleteLocalVideoGroupThunk(group));
      await store.dispatch(DeleteVideoFolder(group));
      cb?.call(null);
    } catch (e) {
      cb?.call(e.toString());
    }
  };
}
