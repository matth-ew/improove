import 'package:flutter/material.dart';
// import 'package:improove/screens/details_screen.dart';
// import 'package:improove/widgets/bottom_nav_bar.dart';
// import 'package:improove/widgets/category_card.dart';
// import 'package:improove/widgets/search_bar.dart';
// import 'package:flutter_svg/flutter_svg.dart';

import 'training_screen.dart';
import 'insctructor_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
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
                  MaterialPageRoute(builder: (context) => InstructorScreen()),
                );
              },
              child: const Text("Istruttore")),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrainingScreen()),
                );
              },
              child: const Text("Corso")),
        ],
      ),
    );
  }
}
