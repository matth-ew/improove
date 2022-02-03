import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
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

  await FirebaseAnalytics.instance.setDefaultEventParameters({
    "id": u.id.toString(),
    "referral": u.referral,
    "subscribed": u.subscribed.toString(),
  });
}

Future<void> faSetScreen(String screenName) async {
  debugPrint("EVENTFASCREEN ${screenName}");
  return await FirebaseAnalytics.instance
      .setCurrentScreen(screenName: screenName);
}

Future<void> faCustomEvent(
  String name,
  Map<String, Object?> parameters,
) async {
  debugPrint("EVENTFACUSTOM $name ${parameters.toString()}");
  await FirebaseAnalytics.instance.logEvent(
    name: name,
    parameters: parameters,
  );
}
