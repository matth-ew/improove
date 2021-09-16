import 'package:redux/redux.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/redux/models/models.dart';

final newTrainingReducer = combineReducers<Map<int, Training>>(
    [TypedReducer<Map<int, Training>, SetNewTrainings>(_setNewTrainings)]);

Map<int, Training> _setNewTrainings(
    Map<int, Training> newTrainings, SetNewTrainings action) {
  return Map.from(newTrainings)..addAll(action.newTrainings);
}
