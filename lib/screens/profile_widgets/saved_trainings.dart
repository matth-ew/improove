import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:improove/redux/models/training.dart';
import 'package:improove/redux/models/user.dart';
import 'package:improove/screens/training_screen.dart';
import 'package:improove/widgets/row_card.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// import 'package:video_player/video_player.dart';

class SavedTrainings extends StatelessWidget {
  final PersistentTabController controller;
  final List<SavedTraining> savedTrainings;
  final Map<int, Training> trainings;
  final Function removeTraining;
  final Function ctaAction;
  const SavedTrainings(
      {Key? key,
      required this.savedTrainings,
      required this.removeTraining,
      required this.ctaAction,
      required this.trainings,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      // padding: EdgeInsets.all(5),
      children: [
        Visibility(
          visible: savedTrainings.isEmpty,
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/icons/training.svg',
                width: 300,
              ),
              Text(
                AppLocalizations.of(context)!.ctaSavedTrainings,
                style: textTheme.subtitle2,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  ctaAction();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.explore),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 8.0,
                      ),
                      child: Text(AppLocalizations.of(context)!.explore),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  // minimumSize: const Size(300, 0),
                  shape: const StadiumBorder(),
                ),
              ),
            ],
          ),
        ),
        ...savedTrainings.map((s) {
          final Training? t = trainings[s.trainingId];
          return Column(
            children: [
              RowCard(
                  preview: t?.preview,
                  name: t?.title,
                  category: t?.category,
                  onTap: () {
                    pushNewScreen(
                      context,
                      screen: TrainingScreen(id: s.trainingId),
                      withNavBar: true,
                      pageTransitionAnimation: Platform.isIOS
                          ? PageTransitionAnimation.cupertino
                          : PageTransitionAnimation.fade,
                    );
                  },
                  actions: [
                    PopupMenuButton(
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            child: Text(AppLocalizations.of(context)!.remove),
                            onTap: () {
                              removeTraining(s.trainingId);
                            },
                          )
                        ];
                      },
                      child: const Icon(
                        Icons.more_vert,
                        size: 30,
                        color: Colors.grey,
                      ),
                    ),
                  ]),
            ],
          );
        }),
      ],
    );
  }
}
