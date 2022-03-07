import 'dart:convert';
import 'package:meta/meta.dart';

class Exercise {
  final String id;
  final String title;
  final String description;
  final String preview;
  final String video;
  final List<String> how;
  final List<String> tips;
  final List<String> mistakes;
  final String goal;

  const Exercise({
    required this.id,
    required this.title,
    required this.description,
    required this.preview,
    required this.video,
    required this.tips,
    required this.how,
    required this.mistakes,
    required this.goal,
  });

  Exercise.fromJson(Map<String, dynamic> json)
      : id = (json['id'] ?? "") as String,
        title = (json['title'] ?? "") as String,
        description = (json['description'] ?? "") as String,
        preview = (json['preview'] ?? "") as String,
        video = (json['video'] ?? "") as String,
        tips = (json['tips'] ?? const []).cast<String>(),
        // tips = List<String>.from(json['tips'] ?? const []) as List),
        // .map((t) => tips.fromJson(t as Map<String, dynamic>))),
        // tips = (json['tips'] ?? "") as List<String>,
        how = (json['how'] ?? const []).cast<String>(),
        mistakes = (json['mistakes'] ?? const []).cast<String>(),
        goal = (json['goal'] ?? "") as String;

  dynamic toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'tips': tips,
        'mistakes': mistakes,
        'how': how,
        'video': video,
        'preview': preview,
        'goal': goal,
      };

  Exercise copyWith(
      {String? id,
      String? title,
      String? description,
      List<String>? tips,
      String? goal,
      List<String>? mistakes,
      List<String>? how,
      String? video,
      String? preview}) {
    return Exercise(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      preview: preview ?? this.preview,
      tips: tips ?? this.tips,
      how: how ?? this.how,
      mistakes: mistakes ?? this.mistakes,
      goal: goal ?? this.goal,
      video: video ?? this.video,
    );
  }

  @override
  String toString() {
    return 'Exercise: ${const JsonEncoder.withIndent('  ').convert(this)}';
  }
}

// class Goal {
//   final int position;
//   final String description;

//   const Goal({
//     required this.position,
//     required this.description,
//   });

//   Goal.fromJson(Map<String, dynamic> json)
//       : position = (json['position'] ?? -1) as int,
//         description = (json['description'] ?? "") as String;

//   dynamic toJson() => {
//         'position': position,
//         'description': description,
//       };

//   Goal copyWith({
//     int? position,
//     String? description,
//   }) {
//     return Goal(
//       position: position ?? this.position,
//       description: description ?? this.description,
//     );
//   }

//   @override
//   String toString() {
//     return 'Goal: ${const JsonEncoder.withIndent('  ').convert(this)}';
//   }
// }

@immutable
class Training {
  final int id;
  final String title;
  final String duration;
  final String preview;
  final String category;
  final int freeExercises;
  final int trainerId;
  final String trainerImage;
  final String trainerName;
  final String trainerSurname;
  final String description;
  final int exercisesLength;
  final List<Exercise> exercises;
  // final List<Goal> goals;

  const Training({
    required this.id,
    required this.title,
    required this.duration,
    required this.preview,
    required this.category,
    required this.freeExercises,
    required this.trainerId,
    required this.trainerImage,
    required this.trainerName,
    required this.trainerSurname,
    required this.description,
    required this.exercisesLength,
    required this.exercises,
    // required this.goals,
  });

  const Training.initial()
      : id = -1,
        title = "",
        duration = "",
        preview = "",
        category = "",
        freeExercises = 0,
        trainerId = -1,
        trainerImage = "",
        trainerName = "",
        trainerSurname = "",
        description = "",
        exercisesLength = 0,
        // goals = const [],
        exercises = const [];

  Training copyWith({
    int? id,
    String? title,
    String? duration,
    String? preview,
    String? category,
    int? freeExercises,
    int? trainerId,
    String? trainerImage,
    String? trainerName,
    String? trainerSurname,
    String? description,
    int? exercisesLength,
    List<Exercise>? exercises,
    // List<Goal>? goals,
  }) {
    return Training(
      id: id ?? this.id,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      preview: preview ?? this.preview,
      category: category ?? this.category,
      freeExercises: freeExercises ?? this.freeExercises,
      trainerId: trainerId ?? this.trainerId,
      trainerImage: trainerImage ?? this.trainerImage,
      trainerName: trainerName ?? this.trainerName,
      trainerSurname: trainerSurname ?? this.trainerSurname,
      description: description ?? this.description,
      exercisesLength: exercisesLength ?? this.exercisesLength,
      exercises: exercises ?? this.exercises,
      // goals: goals ?? this.goals,
    );
  }

  dynamic toJson() => {
        'id': id,
        'title': title,
        'duration': duration,
        'preview': preview,
        'category': category,
        'trainer': trainerId,
        'exercisesLength': exercisesLength,
        'description': description,
        'exercises': exercises,
        // 'goals': goals,
      };

  Training.fromJsonUnpopulated(Map<String, dynamic> json)
      : id = (json['_id'] ?? -1) as int,
        title = (json['title'] ?? "") as String,
        duration = (json['duration'] ?? "") as String,
        preview = (json['preview'] ?? "") as String,
        category = (json['category'] ?? "") as String,
        description = (json['description'] ?? "") as String,
        exercisesLength = (json['exercises_length'] ?? 0) as int,
        freeExercises = (json['free_exercises'] ?? 0) as int,
        exercises = List<Exercise>.from(
            ((json['exercises'] ?? const []) as List)
                .map((t) => Exercise.fromJson(t as Map<String, dynamic>))),
        // goals = List<Goal>.from(((json['goals'] ?? const []) as List)
        //     .map((t) => Goal.fromJson(t as Map<String, dynamic>))),
        trainerId = (json['trainer_id'] ?? -1) as int,
        trainerImage = (json['trainer_image'] ?? "") as String,
        trainerName = (json['trainer_name'] ?? "") as String,
        trainerSurname = (json['trainer_surname'] ?? "") as String;

  Training.fromJson(dynamic json)
      : id = (json['_id'] ?? -1) as int,
        title = (json['title'] ?? "") as String,
        duration = (json['duration'] ?? "") as String,
        preview = (json['preview'] ?? "") as String,
        category = (json['category'] ?? "") as String,
        freeExercises = (json['freeExercises'] ?? 0) as int,
        description = (json['description'] ?? "") as String,
        exercisesLength = (json['exercises_length'] ?? 0) as int,
        exercises = List<Exercise>.from(
            ((json['exercises'] ?? const []) as List)
                .map((t) => Exercise.fromJson(t as Map<String, dynamic>))),
        // goals = List<Goal>.from(((json['goals'] ?? const []) as List)
        //     .map((t) => Goal.fromJson(t as Map<String, dynamic>))),
        trainerId = (json['trainer_id']?["_id"] ?? -1) as int,
        trainerName = (json['trainer_id']?["name"] ?? "") as String,
        trainerSurname = (json['trainer_id']?["surname"] ?? "") as String,
        trainerImage = (json['trainer_id']?["profileImage"] ?? "") as String;

  @override
  String toString() {
    return 'Training: ${const JsonEncoder.withIndent('  ').convert(this)}';
  }
}
