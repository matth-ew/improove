import 'package:redux/redux.dart';
import 'package:improove/redux/actions/actions.dart';
// import 'package:improove/redux/models/models.dart';

final newTrainersReducer = combineReducers<List<int>>([
  TypedReducer<List<int>, SetNewTrainersIds>(_setNewTrainers),
]);

List<int> _setNewTrainers(List<int> newTrainersIds, SetNewTrainersIds action) {
  return action.trainersIds;
}
