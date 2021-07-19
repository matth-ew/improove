import 'package:flutter/material.dart';
import 'package:improove_flutter/screens/details_screen.dart';
// import 'package:improove_flutter/widgets/bottom_nav_bar.dart';
import 'package:improove_flutter/widgets/category_card.dart';
import 'package:improove_flutter/widgets/search_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:improove_flutter/data.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context)
        .size; //this gonna give us total height and with of our device
    return Scaffold(
        // bottomNavigationBar: BottomNavBar(),
        body: Column(
      children: [
        SizedBox(
          height: 20.0,
        ),
        Center(
          child: CircleAvatar(
            foregroundImage: NetworkImage(currentUser.profileImageUrl),
            // radius: size.width * 0.2,
            minRadius: 20.0,
            maxRadius: 100.0,
          ),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
    ));
  }
}
