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
        preview = "assets/images/training_preview.png";

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
