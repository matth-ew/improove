import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/screens/nav_screen.dart';
import 'package:improove/theme/custom_theme.dart';
import 'package:improove/redux/store.dart';

void main() {
  final store = createStore();
  // runApp(App(store: store));
  runApp(StoreProvider(store: store, child: App()));
}

class App extends StatelessWidget {
  //App({this.store});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      title: 'Improove',
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      home: NavScreen(),
    );
  }
}
