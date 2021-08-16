import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:improove/screens/exercise_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'authentication_screen.dart';
import 'trainer_screen.dart';
import 'training_screen.dart';

class HomeScreen extends StatelessWidget {
  final int trainerId = 4;
  final int trainingId = -1;
  final int progressionId = 0;
  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return CupertinoPageScaffold(
      // bottomNavigationBar: BottomNavBar(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
              onPressed: () {
                pushNewScreen(
                  context,
                  screen: TrainerScreen(id: trainerId),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: const Text("Istruttore")),
          TextButton(
              onPressed: () {
                pushNewScreen(
                  context,
                  screen: TrainingScreen(id: trainingId),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: const Text("Corso")),
          TextButton(
              onPressed: () {
                pushNewScreen(
                  context,
                  screen: ExerciseScreen(
                    id: progressionId,
                    trainingId: trainingId,
                  ),
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
