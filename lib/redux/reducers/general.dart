import 'package:improove/redux/models/general.dart';
import 'package:redux/redux.dart';
import 'package:improove/redux/actions/actions.dart';

final generalReducer = combineReducers<General>([
  TypedReducer<General, SetGeneral>(_setGeneral),
]);

General _setGeneral(General general, SetGeneral action) {
  return action.general;
}
