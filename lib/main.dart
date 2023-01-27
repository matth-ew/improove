// import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:isolate';

// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/screens/splash_screen.dart';
import 'package:improove/theme/custom_theme.dart';
import 'package:improove/redux/store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

Future<void> main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://062946683aac4298b2dc938dff2331c3@o1164148.ingest.sentry.io/6253034';
      },
    );

    if (kDebugMode) {
      // Force disable Crashlytics collection while doing every day development.
      // Temporarily toggle this to true if you want to test crash reporting in your app.
      // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    }

    // Pass all uncaught errors from the framework to Crashlytics.
    // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    // Errors outside Flutter
    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await Sentry.captureException(
        errorAndStacktrace.first,
        stackTrace: errorAndStacktrace.last,
      );
    }).sendPort);
    //await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final store = await createStore();
    // runApp(App(store: store));
    runApp(StoreProvider(store: store, child: const App()));
  }, (error, stack) async {
    // await FirebaseCrashlytics.instance.recordError(error, stack);
    await Sentry.captureException(error, stackTrace: stack);
  });
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  //App({this.store});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        // systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: MaterialApp(
        // debugShowCheckedModeBanner: false,
        title: 'Improove',
        theme: CustomTheme.lightTheme,
        // darkTheme: CustomTheme.darkTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SplashScreen(),
      ),
    );
  }
}
