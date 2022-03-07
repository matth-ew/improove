import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/utility/video.dart';
import 'package:improove/widgets/image_picker_cropper.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:math';
import 'package:uuid/uuid.dart';

import 'package:video_thumbnail/video_thumbnail.dart';

import 'ct_form_field.dart';

class ExerciseDetails extends StatefulWidget {
  final String video;
  final Function? onSave;
  const ExerciseDetails({
    required this.video,
    Key? key,
    this.onSave,
  }) : super(key: key);

  @override
  State<ExerciseDetails> createState() => _ExerciseDetailsState();
}

class _ExerciseDetailsState extends State<ExerciseDetails> {
  final _tipsC = <FormFieldHolder>[];
  final _howC = <FormFieldHolder>[];
  final _mistakesC = <FormFieldHolder>[];
  final TextEditingController _titleC = TextEditingController();
  final TextEditingController _descriptionC = TextEditingController();
  final TextEditingController _goalC = TextEditingController();
  String? preview;

  void addHow() {
    // var _controller = TextEditingController();
    var field = FormFieldHolder();

    setState(() {
      _howC.add(field);
    });
    field.focusNode.requestFocus();
  }

  void removeHow(FormFieldHolder _c) {
    setState(() {
      _howC.removeWhere((element) => element == _c);
    });
  }

  void addTips() {
    // var _controller = TextEditingController();
    var field = FormFieldHolder();

    setState(() {
      _tipsC.add(field);
    });
    field.focusNode.requestFocus();
  }

  void removeTips(FormFieldHolder _c) {
    setState(() {
      _tipsC.removeWhere((element) => element == _c);
    });
  }

  void addMistakes() {
    // var _controller = TextEditingController();
    var field = FormFieldHolder();

    setState(() {
      _mistakesC.add(field);
    });
    field.focusNode.requestFocus();
  }

  void removeMistakes(FormFieldHolder _c) {
    setState(() {
      _mistakesC.removeWhere((element) => element == _c);
    });
  }

  @override
  void dispose() {
    _tipsC.map((_c) => _c.dispose());
    _howC.map((_c) => _c.dispose());
    _mistakesC.map((_c) => _c.dispose());

    _titleC.dispose();
    _descriptionC.dispose();
    _goalC.dispose();

    super.dispose();
  }

  void initThumbnail() async {
    var _preview = await VideoThumbnail.thumbnailFile(
      video: widget.video,
      imageFormat: ImageFormat.WEBP,
      maxHeight: 600,
      maxWidth:
          800, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 90,
    );
    if (_preview != null) {
      setState(() {
        preview = _preview;
      });
    }
  }

  @override
  void initState() {
    initThumbnail();
    super.initState();
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
      ),
    );
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
      builder: (BuildContext context, _ViewModel vm) {
        // String? trainerImage = vm.training?.trainerImage;
        return WillPopScope(
          onWillPop: () async {
            showPopDialog();
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: colorScheme.background,
              iconTheme: iconTheme.copyWith(color: colorScheme.onSurface),
              titleTextStyle: textTheme.headline6?.copyWith(
                color: colorScheme.onBackground,
              ),
              title: Text(AppLocalizations.of(context)!.ct_newExercise),
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
                onPressed: () {
                  var uuid = const Uuid();
                  vm.addExercise(Exercise(
                    id: uuid.v1(),
                    title: _titleC.text,
                    description: _descriptionC.text,
                    goal: _goalC.text,
                    video: widget.video,
                    preview: preview ?? "",
                    tips: _tipsC.map((_c) => _c.controller.text).toList(),
                    how: _howC.map((_c) => _c.controller.text).toList(),
                    mistakes:
                        _mistakesC.map((_c) => _c.controller.text).toList(),
                  ));
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(min(size.width * 0.8, 350), 50),
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  AppLocalizations.of(context)!.ct_add,
                  style: const TextStyle(fontSize: 20),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: min(size.width * 0.8, 180),
                            child: AspectRatio(
                              aspectRatio: 1.54,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                child: preview != null
                                    ? Image(
                                        image: FileImage(File(preview!)),
                                        fit: BoxFit.cover,
                                      )
                                    : const ColoredBox(color: Colors.grey),
                              ),
                            ),
                          ),
                          TextButton(
                            child: Text(
                              AppLocalizations.of(context)!.ct_changePreview,
                            ),
                            onPressed: () async {
                              try {
                                final File? fileToSave =
                                    await showImagePickerCropper(
                                  context,
                                  600,
                                  800,
                                  null,
                                  const CropAspectRatio(ratioX: 16, ratioY: 9),
                                );
                                if (fileToSave != null) {
                                  setState(() {
                                    preview = fileToSave.path;
                                  });
                                  // vm.changeProfileImage(fileToSave, (String? e) {
                                  //   Navigator.pop(context);
                                  // });
                                }
                              } catch (e) {
                                debugPrint(
                                    "Errore in selezione immagine ${e.toString()}");
                              }
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: _titleC,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 5, 20, 5),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            // labelText: 'Email',
                            hintText: AppLocalizations.of(context)!.ct_title,
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: _goalC,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 5, 20, 5),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            // labelText: 'Email',
                            hintText: AppLocalizations.of(context)!.ct_goal,
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: _descriptionC,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 5, 20, 5),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            // labelText: 'Email',
                            hintText:
                                AppLocalizations.of(context)!.ct_description,
                          ),
                          minLines: 1,
                          maxLines: 3,
                          textInputAction: TextInputAction.newline,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.howToPerform,
                              style: textTheme.headline6,
                            ),
                            ..._howC.map(
                              (e) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: e.builder(() => removeHow(e), context),
                              ),
                            ),
                            TextButton(
                                child: Text(
                                    AppLocalizations.of(context)!.ct_add_elem),
                                onPressed: addHow),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.commonMistakes,
                              style: textTheme.headline6,
                            ),
                            ..._mistakesC.map(
                              (e) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child:
                                    e.builder(() => removeMistakes(e), context),
                              ),
                            ),
                            TextButton(
                                child: Text(
                                    AppLocalizations.of(context)!.ct_add_elem),
                                onPressed: addMistakes),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.tips,
                              style: textTheme.headline6,
                            ),
                            ..._tipsC.map((e) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child:
                                      e.builder(() => removeTips(e), context),
                                )),
                            TextButton(
                                child: Text(
                                    AppLocalizations.of(context)!.ct_add_elem),
                                onPressed: addTips),
                          ],
                        ),
                      ),
                    ],
                  ),
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
  final User user;
  final Training inCreationTraining;
  final Function(Exercise) addExercise;

  _ViewModel({
    required this.user,
    required this.inCreationTraining,
    required this.addExercise,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      user: store.state.user,
      inCreationTraining: store.state.inCreationTraining,
      addExercise: (Exercise e) => store.dispatch(AddICTExercise(e)),
    );
  }
}
