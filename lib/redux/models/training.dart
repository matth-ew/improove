import 'dart:convert';
import 'package:meta/meta.dart';

@immutable
class Training {
  final String name;
  final String duration;
  final String preview;

  const Training(
      {required this.name, required this.duration, required this.preview});

  const Training.initial()
      : name = "Dragonflag",
        duration = "18 minuti",
        preview =
            "https://images.unsplash.com/photo-1619361728853-2542f3864532?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80";

  Training copyWith({String? name, String? duration, String? preview}) {
    return Training(
        name: name ?? this.name,
        duration: duration ?? this.duration,
        preview: preview ?? this.preview);
  }

  dynamic toJson() => {
        'name': name,
        'duration': duration,
        'preview': preview,
      };

  @override
  String toString() {
    return 'Training: ${const JsonEncoder.withIndent('  ').convert(this)}';
  }
}
