import 'package:redux/redux.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/redux/models/models.dart';

final trainerReducer = combineReducers<Map<int, User>>([
  TypedReducer<Map<int, User>, SetTrainer>(_setTrainerById),
]);

Map<int, User> _setTrainerById(Map<int, User> trainers, SetTrainer action) {
  return Map.from(trainers)..addAll({action.id: action.trainer});
}
