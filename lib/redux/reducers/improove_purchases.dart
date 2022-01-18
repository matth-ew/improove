import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/redux/models/models.dart';

final improovePurchasesReducer = combineReducers<ImproovePurchases>([
  TypedReducer<ImproovePurchases, SetImproovePurchases>(_setImproovePurchases),
  // TypedReducer<ImproovePurchases, DeleteImproovePurchases>(_deleteimproovePurchases),
  // TypedReducer<ImproovePurchases, UpdateFolder>(_changeFolderName),
  // TypedReducer<Map<int, Training>, SetTraining>(_setTrainingById),
  // TypedReducer<Map<int, Training>, SetExercise>(_setExerciseByTitle)
]);

ImproovePurchases _setImproovePurchases(
    ImproovePurchases improovePurchases, SetImproovePurchases action) {
  return action.ip;
}
