import 'package:redux/redux.dart';
import 'package:improove/redux/actions/actions.dart';
// import 'package:improove/redux/models/models.dart';

final exploreTrainingsReducer = combineReducers<List<int>>([
  TypedReducer<List<int>, SetExploreTrainingsIds>(_setExploreTrainings),
]);

List<int> _setExploreTrainings(
    List<int> exploreTrainingsIds, SetExploreTrainingsIds action) {
  return action.trainingsIds;
}
