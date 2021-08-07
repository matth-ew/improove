import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/models/app_state.dart';
import 'package:improove/redux/models/models.dart';
// import 'package:improove/widgets/bottom_nav_bar.dart';
import 'package:improove/widgets/preview_card.dart';
import 'package:improove/widgets/cta_card.dart';
import 'package:redux/redux.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //this gonna give us total height and with of our device
    return Scaffold(
      // bottomNavigationBar: BottomNavBar(),
      body: Column(
        children: [
          SizedBox(
            height: 20.0,
          ),
          Center(
            child: CircleAvatar(
              // radius: size.width * 0.2,
              minRadius: 20.0,
              maxRadius: 100.0,
            ),
          ),
          // PreviewCard(
          //   name: vm.trainings[1]!.title,
          //   duration: vm.trainings[1]!.duration,
          //   preview: vm.trainings[1]!.preview,
          //   avatar: vm.user.image,
          // ),
          CtaCard(),
        ],
      ),
    );
  }
}

class _ViewModel {
  final Map<int, Training> trainings;
  final User user;

  _ViewModel({required this.trainings, required this.user});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(trainings: store.state.trainings, user: store.state.user);
  }
}
