import 'package:improove/redux/models/app_state.dart';
import 'package:improove/redux/reducers/reducers.dart';

AppState appReducer(AppState state, dynamic action) => AppState(
    user: userReducer(state.user, action),
    trainings: trainingReducer(state.trainings, action),
    localVideos: localVideoReducer(state.localVideos, action),
    exploreTrainingsIds:
        exploreTrainingsReducer(state.exploreTrainingsIds, action),
    newTrainingsIds: newTrainingsReducer(state.newTrainingsIds, action),
    trainers: trainerReducer(state.trainers, action));
