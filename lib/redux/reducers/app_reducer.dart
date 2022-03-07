import 'package:improove/redux/models/app_state.dart';
import 'package:improove/redux/reducers/general.dart';
import 'package:improove/redux/reducers/reducers.dart';

AppState appReducer(AppState state, dynamic action) => AppState(
      user: userReducer(state.user, action),
      trainings: trainingReducer(state.trainings, action),
      improovePurchases:
          improovePurchasesReducer(state.improovePurchases, action),
      localVideos: localVideoReducer(state.localVideos, action),
      videoFolders: videoFolderReducer(state.videoFolders, action),
      exploreTrainingsIds:
          exploreTrainingsReducer(state.exploreTrainingsIds, action),
      newTrainingsIds: newTrainingsReducer(state.newTrainingsIds, action),
      newTrainersIds: newTrainersReducer(state.newTrainersIds, action),
      general: generalReducer(state.general, action),
      trainers: trainerReducer(state.trainers, action),
      inCreationTraining:
          inCreationTrainingReducer(state.inCreationTraining, action),
    );
