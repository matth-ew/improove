import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:improove/screens/exercise_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'authentication_screen.dart';
import 'trainer_screen.dart';
import 'training_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  final String trainer_id = "blabla";
  final int training_id = -1;
  final int progression_id = 0;
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context)
        .size; //this gonna give us total height and with of our device
    return CupertinoPageScaffold(
      // bottomNavigationBar: BottomNavBar(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
              onPressed: () {
                pushNewScreen(
                  context,
                  screen: TrainerScreen(id: trainer_id),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: const Text("Istruttore")),
          TextButton(
              onPressed: () {
                pushNewScreen(
                  context,
                  screen: TrainingScreen(id: training_id),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: const Text("Corso")),
          TextButton(
              onPressed: () {
                pushNewScreen(
                  context,
                  screen: ExerciseScreen(id: progression_id),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: const Text("Progressione")),
          TextButton(
              onPressed: () {
                pushNewScreen(
                  context,
                  screen: AuthenticationScreen(),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: const Text("Accesso")),
        ],
      ),
    );
  }
}
