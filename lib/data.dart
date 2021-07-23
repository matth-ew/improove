class User {
  final String username;
  final String profileImageUrl;
  final String thumbnailUrl;
  final String subscribers;

  const User({
    required this.username,
    required this.profileImageUrl,
    required this.thumbnailUrl,
    required this.subscribers,
  });
}

class Training {
  final String name;
  final String duration;
  final String preview;
  final String description;

  const Training({
    required this.name,
    required this.duration,
    required this.preview,
    required this.description,
  });
}

const User currentUser = User(
  username: 'Marcus Ng',
  thumbnailUrl:
      'https://images.unsplash.com/photo-1526506118085-60ce8714f8c5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
  profileImageUrl:
      'https://yt3.ggpht.com/ytc/AAUvwniE2k5PgFu9yr4sBVEs9jdpdILdMc7ruiPw59DpS0k=s88-c-k-c0x00ffffff-no-rj',
  subscribers: '100K',
);

const Training fakeTraining = Training(
  name: 'Dragonflag',
  preview:
      'https://workout-temple.com/media/ExercisesPics/dragon-flag-small.jpg',
  description:
      "La dragon flag è uno degli esercizi più popolari e famosi del corpo libero, del calisthenics e non solo. Anche se normalmente viene inserito solo in programmi di allenamento a corpo libero può costituire un movimento di preparazione fisica utilizzo in tantissimi ambiti sportivi a partire dal crossfit, passando dall’arrampicata sino al canottaggio e al nuoto. E’ innegabile come sia diventato un gesto popolare anche nel mondo del cinema grazie a Sylvester stallone nei film di rocky ma anche nel mondo della arti marziali grazie a Bruce Lee. In questo articolo ti mostrerò come analizzare questo esercizio dal punto di vista biomeccanico ed esecutive e, dove possibile, cercherò di sfatare, con logica, uno dei più grandi miti: è un esercizio per l’addome o un esercizio per il dorso?",
  duration: '7 minutes',
);

class Video {
  final String id;
  final User author;
  final String title;
  final String thumbnailUrl;
  final String duration;
  final DateTime timestamp;
  final String viewCount;
  final String likes;
  final String dislikes;

  const Video({
    required this.id,
    required this.author,
    required this.title,
    required this.thumbnailUrl,
    required this.duration,
    required this.timestamp,
    required this.viewCount,
    required this.likes,
    required this.dislikes,
  });
}

final List<Video> videos = [
  Video(
    id: 'x606y4QWrxo',
    author: currentUser,
    title: 'Flutter Clubhouse Clone UI Tutorial | Apps From Scratch',
    thumbnailUrl: 'https://i.ytimg.com/vi/x606y4QWrxo/0.jpg',
    duration: '8:20',
    timestamp: DateTime(2021, 3, 20),
    viewCount: '10K',
    likes: '958',
    dislikes: '4',
  ),
  Video(
    author: currentUser,
    id: 'vrPk6LB9bjo',
    title:
        'Build Flutter Apps Fast with Riverpod, Firebase, Hooks, and Freezed Architecture',
    thumbnailUrl: 'https://i.ytimg.com/vi/vrPk6LB9bjo/0.jpg',
    duration: '22:06',
    timestamp: DateTime(2021, 2, 26),
    viewCount: '8K',
    likes: '485',
    dislikes: '8',
  ),
  Video(
    id: 'ilX5hnH8XoI',
    author: currentUser,
    title: 'Flutter Instagram Stories',
    thumbnailUrl: 'https://i.ytimg.com/vi/ilX5hnH8XoI/0.jpg',
    duration: '10:53',
    timestamp: DateTime(2020, 7, 12),
    viewCount: '18K',
    likes: '1k',
    dislikes: '4',
  ),
];

final List<Video> suggestedVideos = [
  Video(
    id: 'rJKN_880b-M',
    author: currentUser,
    title: 'Flutter Netflix Clone Responsive UI Tutorial | Web and Mobile',
    thumbnailUrl: 'https://i.ytimg.com/vi/rJKN_880b-M/0.jpg',
    duration: '1:13:15',
    timestamp: DateTime(2020, 8, 22),
    viewCount: '32K',
    likes: '1.9k',
    dislikes: '7',
  ),
  Video(
    id: 'HvLb5gdUfDE',
    author: currentUser,
    title: 'Flutter Facebook Clone Responsive UI Tutorial | Web and Mobile',
    thumbnailUrl: 'https://i.ytimg.com/vi/HvLb5gdUfDE/0.jpg',
    duration: '1:52:12',
    timestamp: DateTime(2020, 8, 7),
    viewCount: '190K',
    likes: '9.3K',
    dislikes: '45',
  ),
  Video(
    id: 'h-igXZCCrrc',
    author: currentUser,
    title: 'Flutter Chat UI Tutorial | Apps From Scratch',
    thumbnailUrl: 'https://i.ytimg.com/vi/h-igXZCCrrc/0.jpg',
    duration: '1:03:58',
    timestamp: DateTime(2019, 10, 17),
    viewCount: '358K',
    likes: '20k',
    dislikes: '85',
  ),
];
