import 'package:redux/redux.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/redux/models/models.dart';

final localVideoReducer = combineReducers<List<LocalVideo>>([
  TypedReducer<List<LocalVideo>, AddLocalVideo>(_addLocalVideo),
  TypedReducer<List<LocalVideo>, MoveLocalVideos>(_moveLocalVideos),
  TypedReducer<List<LocalVideo>, DeleteLocalVideo>(_deleteLocalVideo),
  TypedReducer<List<LocalVideo>, DeleteLocalVideoGroup>(_deleteLocalVideoGroup),
  // TypedReducer<Map<int, Training>, SetTraining>(_setTrainingById),
  // TypedReducer<Map<int, Training>, SetExercise>(_setExerciseByTitle)
]);

List<LocalVideo> _addLocalVideo(
    List<LocalVideo> localVideos, AddLocalVideo action) {
  return List.from(localVideos)..add(action.video);
}

List<LocalVideo> _moveLocalVideos(
    List<LocalVideo> localVideos, MoveLocalVideos action) {
  return localVideos.map((LocalVideo v) {
    if (action.paths.contains(v.path)) {
      return v.copyWith(group: action.group);
    } else {
      return v;
    }
  }).toList();
}

List<LocalVideo> _deleteLocalVideo(
    List<LocalVideo> localVideos, DeleteLocalVideo action) {
  return localVideos.where((v) => v.path != action.path).toList();
}

List<LocalVideo> _deleteLocalVideoGroup(
    List<LocalVideo> localVideos, DeleteLocalVideoGroup action) {
  return localVideos.where((v) => v.group != action.group).toList();
}
// List<Todo> _deleteTodo(List<Todo> todos, DeleteTodoAction action) {
//   return todos.where((todo) => todo.id != action.id).toList();
// }