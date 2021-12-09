import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/redux/models/models.dart';

final videoFolderReducer = combineReducers<List<VideoFolder>>([
  TypedReducer<List<VideoFolder>, AddVideoFolder>(_addVideoFolder),
  TypedReducer<List<VideoFolder>, DeleteVideoFolder>(_deleteVideoFolder),
  TypedReducer<List<VideoFolder>, UpdateFolder>(_changeFolderName),
  // TypedReducer<Map<int, Training>, SetTraining>(_setTrainingById),
  // TypedReducer<Map<int, Training>, SetExercise>(_setExerciseByTitle)
]);

List<VideoFolder> _addVideoFolder(
    List<VideoFolder> videoFolders, AddVideoFolder action) {
  return List.from(videoFolders)..add(action.folder);
}

List<VideoFolder> _deleteVideoFolder(
    List<VideoFolder> videoFolders, DeleteVideoFolder action) {
  return videoFolders.where((f) => f.group != action.group).toList();
}

List<VideoFolder> _changeFolderName(
    List<VideoFolder> videoFolders, UpdateFolder action) {
  debugPrint("UE CAGNAMM TUTT COS $videoFolders ${action.updatedFolder}");
  return videoFolders
      .map((folder) => folder.group == action.updatedFolder.group
          ? action.updatedFolder
          : folder)
      .toList();
  //..add(action.name);
}
