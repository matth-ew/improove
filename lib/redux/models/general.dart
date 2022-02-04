class General {
  final int? weekTrainingId;
  // final String name;

  const General({
    required this.weekTrainingId,
  });
  const General.initial() : weekTrainingId = null;
  // name = '';

  General copyWith({int? weekTrainingId}) {
    return General(
      weekTrainingId: weekTrainingId ?? this.weekTrainingId,
    );
  }

  dynamic toJson() => {
        'weekTrainingId': weekTrainingId,
      };
  General.fromJson(dynamic json)
      : weekTrainingId = (json['weekTrainingId'] ?? "") as int?;
}
