import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/models/app_state.dart';
import 'package:improove/redux/selectors/user.dart';
import 'package:improove/screens/details_screen.dart';
// import 'package:improove/widgets/bottom_nav_bar.dart';
import 'package:improove/widgets/category_card.dart';
import 'package:improove/widgets/search_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:improove/data.dart';
import 'package:redux/redux.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
        converter: (Store<AppState> store) => userSelector(store.state.user),
        builder: (BuildContext context, String username) {
          var size = MediaQuery.of(context)
              .size; //this gonna give us total height and with of our device
          return Scaffold(
              // bottomNavigationBar: BottomNavBar(),
              body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
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
              Text(username)
            ],
          ));
        });
  }
}
