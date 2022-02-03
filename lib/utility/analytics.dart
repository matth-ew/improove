import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:improove/redux/models/user.dart';

Future<void> faSetUser(User u) async {
  await FirebaseAnalytics.instance.setUserId(id: u.id.toString());
  await FirebaseAnalytics.instance.setUserProperty(
    name: 'referral',
    value: u.referral,
  );
  await FirebaseAnalytics.instance.setUserProperty(
    name: 'subscribed',
    value: u.subscribed.toString(),
  );
}

Future<void> faSetScreen(String screenName) async {
  return await FirebaseAnalytics.instance
      .setCurrentScreen(screenName: screenName);
}
