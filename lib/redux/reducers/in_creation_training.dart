import 'package:redux/redux.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/redux/models/models.dart';

final inCreationTrainingReducer = combineReducers<Training>([
  TypedReducer<Training, SetInCreationTraining>(_setTraining),
  TypedReducer<Training, AddICTExercise>(_addExercise),
  TypedReducer<Training, RemoveICTExercise>(_removeExercise),
  TypedReducer<Training, ReorderICTExercise>(_reorderExercise),
  TypedReducer<Training, ICTReset>(_reset),
  // TypedReducer<Map<int, Training>, SetTraining>(_setTrainingById),
  // TypedReducer<Map<int, Training>, SetExercise>(_setExerciseByTitle)
]);

Training _setTraining(
    Training inCreationTraining, SetInCreationTraining action) {
  return action.training;
}

Training _addExercise(Training inCreationTraining, AddICTExercise action) {
  return inCreationTraining.copyWith(
      exercises: List.from(inCreationTraining.exercises)..add(action.exercise));
}

Training _removeExercise(
    Training inCreationTraining, RemoveICTExercise action) {
  return inCreationTraining.copyWith(
      exercises: inCreationTraining.exercises
          .where((e) => e.id != action.id)
          .toList());
}

Training _reset(Training inCreationTraining, ICTReset action) {
  return const Training.initial();
}

Training _reorderExercise(
    Training inCreationTraining, ReorderICTExercise action) {
  final swapEx = inCreationTraining.exercises[action.oldIndex];

  final listWithoutElem =
      inCreationTraining.exercises.where((e) => e.id != swapEx.id).toList();

  int _newIndex = action.newIndex;
  if (action.oldIndex < action.newIndex) {
    _newIndex -= 1;
  }

  return inCreationTraining.copyWith(exercises: [
    ...listWithoutElem.sublist(0, _newIndex),
    swapEx,
    ...listWithoutElem.sublist(_newIndex),
  ]);
}
