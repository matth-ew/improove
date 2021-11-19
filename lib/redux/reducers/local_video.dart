import 'package:redux/redux.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/redux/models/models.dart';

final localVideoReducer = combineReducers<List<LocalVideo>>([
  TypedReducer<List<LocalVideo>, AddLocalVideo>(_addLocalVideo),
  // TypedReducer<Map<int, Training>, SetTraining>(_setTrainingById),
  // TypedReducer<Map<int, Training>, SetExercise>(_setExerciseByTitle)
]);

List<LocalVideo> _addLocalVideo(
    List<LocalVideo> localVideos, AddLocalVideo action) {
  return List.from(localVideos)..add(action.video);
}
