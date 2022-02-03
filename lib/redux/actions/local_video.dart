import 'dart:io';

import 'package:flutter/material.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/utility/analytics.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class AddLocalVideo {
  final LocalVideo video;

  AddLocalVideo(this.video);
}

class MoveLocalVideos {
  final String group;
  final List<String> paths;

  MoveLocalVideos(this.paths, this.group);
}

class DeleteLocalVideo {
  final String path;

  DeleteLocalVideo(this.path);
}

class DeleteLocalVideoGroup {
  final String group;

  DeleteLocalVideoGroup(this.group);
}

ThunkAction<AppState> addLocalVideoThunk(LocalVideo video, [Function? cb]) {
  return (Store<AppState> store) async {
    try {
      faCustomEvent(
        "SAVING_LOCAL_VIDEO",
        {
          "user": store.state.user.id,
        },
      );
      debugPrint("ADDING VIDEO ${video.path}");
      store.dispatch(AddLocalVideo(video));
      cb?.call(null);
    } catch (e) {
      cb?.call(e.toString());
    }
  };
}

ThunkAction<AppState> moveLocalVideosThunk(List<String> paths, String group,
    [Function? cb]) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(MoveLocalVideos(paths, group));
      cb?.call(null);
    } catch (e) {
      cb?.call(e.toString());
    }
  };
}

ThunkAction<AppState> deleteLocalVideosThunk(List<String> paths,
    [Function? cb]) {
  return (Store<AppState> store) async {
    try {
      debugPrint("REMOVING VIDEO ${paths.toString()}");
      await Future.forEach(paths, (String path) async {
        store.dispatch(DeleteLocalVideo(path));
        await File(path).delete();
      });
      cb?.call(null);
    } catch (e) {
      cb?.call(e.toString());
    }
  };
}

ThunkAction<AppState> deleteLocalVideoGroupThunk(String group, [Function? cb]) {
  return (Store<AppState> store) async {
    try {
      await Future.forEach(store.state.localVideos, (LocalVideo elem) async {
        if (group == elem.group) {
          await File(elem.path).delete();
        }
      });
      debugPrint("REMOVING VIDEO GROUP $group");
      store.dispatch(DeleteLocalVideoGroup(group));
      cb?.call(null);
    } catch (e) {
      cb?.call(e.toString());
    }
  };
}
