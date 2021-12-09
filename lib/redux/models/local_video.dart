class LocalVideo {
  final String path;
  final String group;
  // final String name;

  const LocalVideo({
    required this.path,
    required this.group,
    // required this.name,
  });
  const LocalVideo.initial()
      : path = '',
        group = '';
  // name = '';

  LocalVideo copyWith({String? group, String? path}) {
    return LocalVideo(
      path: path ?? this.path,
      group: group ?? this.group,
    );
  }

  dynamic toJson() => {
        'path': path,
        // 'name': name,
        'group': group,
      };
  LocalVideo.fromJson(dynamic json)
      : path = (json['path'] ?? "") as String,
        // name = (json['name'] ?? "") as String,
        group = (json['group'] ?? "") as String;
}
