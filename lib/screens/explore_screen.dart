import 'package:flutter/material.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/widgets/preview_card.dart';
import 'package:improove/widgets/cta_card.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/models/app_state.dart';
import 'package:improove/redux/models/models.dart';
import 'package:redux/redux.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double heightScreen = MediaQuery.of(context).size.height;
    final Size size = MediaQuery.of(context).size;

    return StoreConnector(
        converter: (Store<AppState> store) => _ViewModel.fromStore(store),
        onInit: (store) {
          store.dispatch(getTraining());
        },
        builder: (BuildContext context, _ViewModel vm) {
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  ///Properties of app bar
                  backgroundColor: Colors.white,
                  pinned: true,
                  expandedHeight: heightScreen / 8,

                  ///Properties of the App Bar when it is expanded
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      "Improove",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return SizedBox(
                        child: Center(
                          child: PreviewCard(
                            category: "Category",
                            name: vm.training.title,
                            preview: vm.training.preview,
                          ),
                        ),
                      );
                    },
                    childCount: 10,
                  ),
                ),
                SliverToBoxAdapter(
                    child: SizedBox(
                        height: size.width * (198 / 254) * (135 / 198),
                        width: size.width * (198 / 254),
                        child: CtaCard()))
              ],
            ),
          );
        });
  }
}

class _ViewModel {
  final Training training;

  _ViewModel({required this.training});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(training: store.state.training);
  }
}
