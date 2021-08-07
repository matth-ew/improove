import 'package:flutter/material.dart';
import 'package:improove/screens/exercise_screen.dart';
import 'authentication_screen.dart';
import 'trainer_screen.dart';
import 'training_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  final String trainer_id = "blabla";
  final String training_id = "blabla";
  final int progression_id = 0;
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context)
        .size; //this gonna give us total height and with of our device
    return Scaffold(
      // bottomNavigationBar: BottomNavBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrainerScreen(id: trainer_id),
                  ),
                );
              },
              child: const Text("Istruttore")),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrainingScreen(id: 1),
                  ),
                );
              },
              child: const Text("Corso")),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseScreen(id: progression_id),
                  ),
                );
              },
              child: const Text("Progressione")),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuthenticationScreen(),
                  ),
                );
              },
              child: const Text("Accesso")),
        ],
      ),
    );
  }
}
