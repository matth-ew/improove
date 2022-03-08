import 'package:redux/redux.dart';
import 'package:improove/redux/actions/actions.dart';
// import 'package:improove/redux/models/models.dart';

final unapprovedTrainingsReducer = combineReducers<List<int>>([
  TypedReducer<List<int>, SetUnapprovedTrainingsIds>(_setNewTrainings),
]);

List<int> _setNewTrainings(
    List<int> newTrainingsIds, SetUnapprovedTrainingsIds action) {
  return action.trainingsIds;
}
