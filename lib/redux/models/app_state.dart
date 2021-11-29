// lib/models/app_state.dart
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'models.dart';

@immutable
class AppState {
  final User user;

  //final Training training;
  final Map<int, Training> trainings;
  final List<int> exploreTrainingsIds;
  final List<int> newTrainingsIds;
  final List<LocalVideo> localVideos;
  final List<VideoFolder> videoFolders;
  final Map<int, User> trainers;

  const AppState({
    required this.user,
    required this.trainings,
    required this.exploreTrainingsIds,
    required this.newTrainingsIds,
    required this.localVideos,
    required this.videoFolders,
    required this.trainers,
  });
  const AppState.initial()
      : trainings = const {},
        exploreTrainingsIds = const [],
        newTrainingsIds = const [],
        user = const User.initial(),
        localVideos = const [],
        videoFolders = const [],
        trainers = const {};

  dynamic toJson() => {
        'user': user.toJson(),
        'local-videos': List<dynamic>.from(localVideos.map((v) => v.toJson())),
        'video-folders':
            List<dynamic>.from(videoFolders.map((f) => f.toJson())),
        //'trainers': trainers.entries.map((e) => {e.key: e.value.toJson()}),
        //'trainings': trainings.entries.map((e) => {e.key: e.value.toJson()}),
      };
  static AppState fromJson(dynamic json) {
    if (json == null) return const AppState.initial();
    return AppState(
      user: User.fromJson(json['user']),
      localVideos: List<LocalVideo>.from(
          (json['local-videos'] ?? []).map((v) => LocalVideo.fromJson(v))),
      videoFolders: List<VideoFolder>.from(
          (json['video-folders'] ?? []).map((f) => VideoFolder.fromJson(f))),
      trainers: const {},
      trainings: const {},
      exploreTrainingsIds: const [],
      newTrainingsIds: const [],
      /*trainers: (json['trainers'] ?? "").map(
        (t) => {
          t["key"]: User.fromJson(
            t["value"],
          ),
        },
      ) as Map<int, User>,
      trainings: (json['trainings'] ?? "").map(
        (t) => {
          t["key"]: Training.fromJson(
            t["value"],
          ),
        },
      ) as Map<int, Training>,*/
    );
  }
  /*
      : user = User.fromJson(json['user']),
        trainers = (json['trainers'] ?? "")
                .map((t) => {t["key"]: User.fromJson(t["value"])})
            as Map<int, User>,
        trainings = (json['trainings'] ?? "")
                .map((t) => {t["key"]: Training.fromJson(t["value"])})
            as Map<int, Training>;
            */
}
