import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _storage = FlutterSecureStorage();

Future<String?> getAccessToken() async {
  return await _storage.read(key: "accessToken");
}

Future<void> setAccessToken(String token) async {
  return await _storage.write(
    key: "accessToken",
    value: token,
  );
}

Future<void> deleteAccessToken() async {
  return await _storage.delete(key: "accessToken");
}

Future<String?> getReferralCode() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('referralCode');
}

// Future<List<LocalVideo>> getLocalVideos() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   List<LocalVideo> videoList = [];
//   await Future.wait((prefs.getStringList('local_videos') ?? []).map((e) async {
//     videoList.add(
//       LocalVideo.fromJson(jsonDecode(e)),
//     );
//   }));

//   return videoList;
// }

// Future<bool> addLocalVideo({
//   required String path,
//   required String group,
//   required String name,
// }) async {
//   LocalVideo video = LocalVideo(path: path, group: group, name: name);
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   List<String> videoList = prefs.getStringList('local_videos') ?? [];
//   // ?.forEach(
//   //       (e) => videoList.add(
//   //         LocalVideo.fromJson(e),
//   //       ),
//   //     );
//   videoList.add(jsonEncode(video.toJson()));
//   return prefs.setStringList('local_videos', videoList);
// }
