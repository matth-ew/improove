import 'package:flutter/material.dart';
import 'package:improove/screens/details_screen.dart';
// import 'package:improove/widgets/bottom_nav_bar.dart';
import 'package:improove/widgets/category_card.dart';
import 'package:improove/widgets/search_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context)
        .size; //this gonna give us total height and with of our device
    return Scaffold(
        // bottomNavigationBar: BottomNavBar(),
        body: Stack());
  }
}
