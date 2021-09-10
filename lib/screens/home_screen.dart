import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:improove/screens/exercise_screen.dart';
import 'package:improove/widgets/cta_card.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'authentication_screen.dart';
import 'package:improove/const/text.dart';
import 'trainer_screen.dart';
import 'training_screen.dart';

class HomeScreen extends StatelessWidget {
  final int trainerId = 4;
  final int trainingId = -1;
  final int progressionId = 0;

  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return CupertinoPageScaffold(
      // bottomNavigationBar: BottomNavBar(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [CtaCard(tag: ctaBecameTrainer), CtaCard(tag: ctaFeedback)],
      ),
    );
  }
}
