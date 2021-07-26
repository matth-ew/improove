import 'package:flutter/material.dart';
import 'package:improove/screens/progression_screen.dart';
import 'trainer_screen.dart';
import 'training_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  final String trainer_id = "blabla";
  final String training_id = "blabla";
  final String progression_id = "blabla";
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
                    builder: (context) => TrainingScreen(id: training_id),
                  ),
                );
              },
              child: const Text("Corso")),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProgressionScreen(id: progression_id),
                  ),
                );
              },
              child: const Text("Progressione")),
        ],
      ),
    );
  }
}
