import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/redux/models/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:improove/widgets/create_training_widgets/ct_exercises_list.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';

class CreateTrainingScreen extends StatefulWidget {
  const CreateTrainingScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateTrainingScreen> createState() => _CreateTrainingScreenState();
}

class _CreateTrainingScreenState extends State<CreateTrainingScreen> {
  final _controller = TextEditingController();

  goToNext(vm) {
    vm.setTraining(
      vm.inCreationTraining.copyWith(
        title: _controller.text,
      ),
    );
    pushNewScreen(
      context,
      screen: CtExercisesList(),
      withNavBar: false,
      pageTransitionAnimation: Platform.isIOS
          ? PageTransitionAnimation.cupertino
          : PageTransitionAnimation.fade,
    );
  }

  showPopDialog() {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.wantDeleteVideo),
              content: Text(AppLocalizations.of(context)!.backLoseVideo),
              actions: [
                TextButton(
                  child: Text(AppLocalizations.of(context)!.no),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    AppLocalizations.of(context)!.delete,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    // final step = h.useState(0);
    final Size size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final iconTheme = Theme.of(context).iconTheme;

    // final controller = h.useTextEditingController();

    return StoreConnector(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      onInit: (Store<AppState> store) {
        _controller.text = store.state.inCreationTraining.title;
      },
      builder: (BuildContext context, _ViewModel vm) {
        // String? trainerImage = vm.training?.trainerImage;
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: colorScheme.background,
            iconTheme: iconTheme.copyWith(color: colorScheme.onSurface),
            titleTextStyle: textTheme.headline6?.copyWith(
              color: colorScheme.onBackground,
            ),
            title: Text(
              AppLocalizations.of(context)!.ct_screenName,
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
            // color: colorScheme.primary,
            decoration: BoxDecoration(
              border: BorderDirectional(
                top: BorderSide(
                  color: colorScheme.onSurface.withOpacity(0.1),
                ),
              ),
            ),
            child: ElevatedButton(
              onPressed: _controller.text.isEmpty ? null : () => goToNext(vm),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(min(size.width * 0.8, 350), 50),
                shape: const StadiumBorder(),
              ),
              child: Text(
                AppLocalizations.of(context)!.ct_next,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                // alignment: Alignment,
                padding: const EdgeInsets.symmetric(vertical: 15),
                constraints: BoxConstraints(
                    minWidth: size.width,
                    minHeight: size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom -
                        100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25.0),
                      child: SvgPicture.asset(
                        'assets/icons/createTraining.svg',
                        width: min(size.width * 0.8, 300),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 25.0),
                      width: min(size.width * 0.8, 350),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.ct_nameCourse,
                            style: textTheme.headline6?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 25),
                          TextFormField(
                            onFieldSubmitted: (value) {
                              goToNext(vm);
                            },
                            controller: _controller,
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                hintText: AppLocalizations.of(context)!
                                    .ct_nameCoursePlaceholder),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel {
  // final List<SavedTraining> savedTrainings;
  // final Training? training;
  final User user;
  final Training inCreationTraining;
  // final Function() getTraining;
  final Function(Training t) setTraining;
  // final Function([Function? cb]) removeTraining;
  // final Function(int, String) setDescription;

  _ViewModel({
    //   required this.savedTrainings,
    // required this.training,
    required this.user,
    required this.inCreationTraining,
    // required this.getTraining,
    required this.setTraining,
    // required this.removeTraining,
    // required this.setDescription,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      // savedTrainings: store.state.user.savedTrainings,
      user: store.state.user,
      inCreationTraining: store.state.inCreationTraining,
      // getTraining: () => store.dispatch(getTrainingById(id)),
      // setDescription: (int id, String text) =>
      //     store.dispatch(setTrainingDescription(id, text)),
      // training: store.state.trainings[id],
      setTraining: (training) => store.dispatch(
        SetInCreationTraining(training),
      ),
      // removeTraining: ([cb]) => store.dispatch(
      //   removeTrainingThunk(id, cb),
      // ),
    );
  }
}
