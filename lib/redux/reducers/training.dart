import 'package:redux/redux.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/redux/models/models.dart';

final trainingReducer = combineReducers<Training>([
  TypedReducer<Training, SetTraining>(_setTrainingReducer),
]);

Training _setTrainingReducer(Training training, SetTraining action) {
  return action.training;
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