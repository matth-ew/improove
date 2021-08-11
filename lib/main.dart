import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/screens/splash_screen.dart';
import 'package:improove/theme/custom_theme.dart';
import 'package:improove/redux/store.dart';

Future<void> main() async {
  final store = await createStore();
  // runApp(App(store: store));
  runApp(StoreProvider(store: store, child: App()));
}

class App extends StatelessWidget {
  //App({this.store});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
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
        home: SplashScreen(),
      ),
    );
  }
}
