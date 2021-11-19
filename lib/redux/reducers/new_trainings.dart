import 'package:redux/redux.dart';
import 'package:improove/redux/actions/actions.dart';
// import 'package:improove/redux/models/models.dart';

final newTrainingsReducer = combineReducers<List<int>>([
  TypedReducer<List<int>, SetNewTrainingsIds>(_setNewTrainings),
]);

List<int> _setNewTrainings(
    List<int> newTrainingsIds, SetNewTrainingsIds action) {
  return action.trainingsIds;
}
