import 'package:redux/redux.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/redux/models/models.dart';

final userReducer = combineReducers<User>([
  TypedReducer<User, SetUser>(_setUserReducer),
  TypedReducer<User, SetFullName>(_setFullNameReducer),
  TypedReducer<User, SetProfileImage>(_setProfileImageReducer),
  TypedReducer<User, AddSavedTraining>(_addSavedTraining),
  TypedReducer<User, DeleteSavedTraining>(_deleteSavedTraining),
  TypedReducer<User, UserLogout>(_userLogoutReducer),
]);

User _setUserReducer(User user, SetUser action) {
  return action.user;
}

User _setFullNameReducer(User user, SetFullName action) {
  return user.copyWith(name: action.name, surname: action.surname);
}

User _setProfileImageReducer(User user, SetProfileImage action) {
  return user.copyWith(profileImage: action.profileImage);
}

User _addSavedTraining(User user, AddSavedTraining action) {
  return user.copyWith(
      savedTrainings: List.from(user.savedTrainings)
        ..add(action.savedTraining));
}

User _deleteSavedTraining(User user, DeleteSavedTraining action) {
  return user.copyWith(
      savedTrainings: user.savedTrainings
          .where((s) => s.trainingId != action.trainingId)
          .toList());
}

User _userLogoutReducer(User user, UserLogout action) {
  return const User.initial();
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