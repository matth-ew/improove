import 'dart:convert';
import 'package:meta/meta.dart';

class Exercise {
  final String title;
  final String preview;
  final String video;
  final String how;
  final String tips;
  final String mistakes;

  const Exercise(
      {required this.title,
      required this.preview,
      required this.video,
      required this.tips,
      required this.how,
      required this.mistakes});

  Exercise.fromJson(Map<String, dynamic> json)
      : title = (json['title'] ?? "") as String,
        preview = (json['preview'] ?? "") as String,
        video = (json['video'] ?? "") as String,
        tips = (json['tips'] ?? "") as String,
        how = (json['how'] ?? "") as String,
        mistakes = (json['mistakes'] ?? "") as String;

  dynamic toJson() => {
        'title': title,
        'tips': tips,
        'mistakes': mistakes,
        'how': how,
        'video': video,
        'preview': preview
      };

  @override
  String toString() {
    return 'Exercise: ${const JsonEncoder.withIndent('  ').convert(this)}';
  }
}

@immutable
class Training {
  final int id;
  final String title;
  final String duration;
  final String preview;
  final String category;
  final int trainerId;
  final String trainerImage;
  final String description;
  final List<Exercise> exercises;

  const Training(
      {required this.id,
      required this.title,
      required this.duration,
      required this.preview,
      required this.category,
      required this.trainerId,
      required this.trainerImage,
      required this.description,
      required this.exercises});

  const Training.initial()
      : id = -1,
        title = "Dragonflag",
        duration = "18 minuti",
        preview =
            "https://images.unsplash.com/photo-1619361728853-2542f3864532?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80",
        category = "no tag",
        trainerId = -1,
        trainerImage = "",
        description = "no description",
        exercises = const [];

  Training copyWith(
      {int? id,
      String? title,
      String? duration,
      String? preview,
      String? category,
      int? trainerId,
      String? trainerImage,
      String? description,
      List<Exercise>? exercises}) {
    return Training(
        id: id ?? this.id,
        title: title ?? this.title,
        duration: duration ?? this.duration,
        preview: preview ?? this.preview,
        category: category ?? this.category,
        trainerId: trainerId ?? this.trainerId,
        trainerImage: trainerImage ?? this.trainerImage,
        description: description ?? this.description,
        exercises: exercises ?? this.exercises);
  }

  dynamic toJson() => {
        'id': id,
        'title': title,
        'duration': duration,
        'preview': preview,
        'category': category,
        'trainer': trainerId,
        'exercises': exercises,
        'description': description
      };

  // Training.fromJson(String title, String duration, String preview)
  //   : title = title,
  //     duration = duration,
  //     preview = preview;

  Training.fromJson(dynamic json)
      : id = (json['_id'] ?? -1) as int,
        title = (json['title'] ?? "") as String,
        duration = (json['duration'] ?? "") as String,
        preview = (json['preview'] ?? "") as String,
        category = (json['category'] ?? "") as String,
        description = (json['description'] ?? "") as String,
        exercises = List<Exercise>.from(
            ((json['video_array'] ?? const []) as List)
                .map((t) => Exercise.fromJson(t as Map<String, dynamic>))),
        trainerId = (json['trainer_id']["_id"] ?? -1) as int,
        trainerImage = (json['trainer_id']["profileImage"] ?? "") as String;

  @override
  String toString() {
    return 'Training: ${const JsonEncoder.withIndent('  ').convert(this)}';
  }
}
