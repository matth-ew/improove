import 'dart:convert';
import 'package:meta/meta.dart';

@immutable
class Training {
  final String title;
  final String duration;
  final String preview;

  const Training(
      {required this.title, required this.duration, required this.preview});

  const Training.initial()
      : title = "Dragonflag",
        duration = "18 minuti",
        preview =
            "https://images.unsplash.com/photo-1619361728853-2542f3864532?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80";

  Training copyWith({String? title, String? duration, String? preview}) {
    return Training(
        title: title ?? this.title,
        duration: duration ?? this.duration,
        preview: preview ?? this.preview);
  }

  dynamic toJson() => {
        'name': title,
        'duration': duration,
        'preview': preview,
      };

  // Training.fromJson(String title, String duration, String preview)
  //   : title = title,
  //     duration = duration,
  //     preview = preview;

  Training.fromJson(Map<String, dynamic> json)
      : title = (json['result.title'] ?? "") as String,
        duration = (json['result.duration'] ?? "") as String,
        preview = (json['result.preview'] ?? "") as String;

  @override
  String toString() {
    return 'Training: ${const JsonEncoder.withIndent('  ').convert(this)}';
  }
}
