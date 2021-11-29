class VideoFolder {
  final String group;
  final String name;

  const VideoFolder({
    required this.group,
    required this.name,
  });
  const VideoFolder.initial()
      : group = '',
        name = '';

  @override
  bool operator ==(Object other) {
    return other is VideoFolder && hashCode == other.hashCode;
  }

  @override
  int get hashCode => group.hashCode;

  dynamic toJson() => {
        'name': name,
        'group': group,
      };
  VideoFolder.fromJson(dynamic json)
      : name = (json['name'] ?? "") as String,
        group = (json['group'] ?? "") as String;
}
