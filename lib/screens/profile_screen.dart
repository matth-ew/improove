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
    return StoreConnector(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {
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
                  // radius: size.width * 0.2,
                  minRadius: 20.0,
                  maxRadius: 100.0,
                ),
              ),
              PreviewCard(
                name: vm.training.name,
                duration: vm.training.duration,
                preview: vm.training.preview,
                avatar: vm.user.image,
              ),
              CtaCard(),
            ],
          ),
        );
      },
    );
  }
}

class _ViewModel {
  final Training training;
  final User user;

  _ViewModel({required this.training, required this.user});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(training: store.state.training, user: store.state.user);
  }
}
