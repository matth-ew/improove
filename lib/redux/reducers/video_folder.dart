import 'package:redux/redux.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/redux/models/models.dart';

final videoFolderReducer = combineReducers<List<VideoFolder>>([
  TypedReducer<List<VideoFolder>, AddVideoFolder>(_addVideoFolder),
  // TypedReducer<Map<int, Training>, SetTraining>(_setTrainingById),
  // TypedReducer<Map<int, Training>, SetExercise>(_setExerciseByTitle)
]);

List<VideoFolder> _addVideoFolder(
    List<VideoFolder> videoFolders, AddVideoFolder action) {
  return List.from(videoFolders)..add(action.folder);
}
