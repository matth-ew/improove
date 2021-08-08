import 'package:redux/redux.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/redux/models/models.dart';

final trainingReducer = combineReducers<Map<int, Training>>([
  TypedReducer<Map<int, Training>, SetTrainings>(_setAllTrainings),
  TypedReducer<Map<int, Training>, SetTraining>(_setTrainingById),
]);

Map<int, Training> _setAllTrainings(
    Map<int, Training> trainings, SetTrainings action) {
  return action.trainings;
}

Map<int, Training> _setTrainingById(
    Map<int, Training> trainings, SetTraining action) {
  trainings[action.id] = action.training;
  return trainings;
}



// List<Todo> _addTodo(List<Todo> todos, AddTodoAction action) {
//   return List.from(todos)..add(action.todo);
// }

// List<Todo> _deleteTodo(List<Todo> todos, DeleteTodoAction action) {
//   return todos.where((todo) => todo.id != action.id).toList();
// }

// List<Todo> _updateTodo(List<Todo> todos, UpdateTodoAction action) {
//   return todos
//       .map((todo) => todo.id == action.id ? action.updatedTodo : todo)
//       .toList();
// }

// List<Todo> _clearCompleted(List<Todo> todos, ClearCompletedAction action) {
//   return todos.where((todo) => !todo.complete).toList();
// }

// List<Todo> _toggleAll(List<Todo> todos, ToggleAllAction action) {
//   final allComplete = allCompleteSelector(todos);

//   return todos.map((todo) => todo.copyWith(complete: !allComplete)).toList();
// }

// List<Todo> _setLoadedTodos(List<Todo> todos, TodosLoadedAction action) {
//   return action.todos;
// }

// List<Todo> _setNoTodos(List<Todo> todos, TodosNotLoadedAction action) {
//   return [];
// }