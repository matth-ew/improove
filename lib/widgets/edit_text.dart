import 'package:flutter/material.dart';
import 'package:improove/widgets/my_expandable_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditTextCard extends StatefulWidget {
  final String text;
  final Function? onDone;

  const EditTextCard({Key? key, required this.text, required this.onDone})
      : super(key: key);

  @override
  _EditTextCard createState() => _EditTextCard();
}

class _EditTextCard extends State<EditTextCard> {
  bool isEditing = false;
  String myText = "";
  bool init = false;

  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (widget.text != "" && !init) {
      myController.text = widget.text;
      myText = widget.text;
      init = !init;
    }

    if (isEditing) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextFormField(
          maxLines: null,
          controller: myController,
        ),
        GestureDetector(
            onTap: () {
              setState(() {
                myText = myController.text;
                isEditing = false;
              });
              widget.onDone!(myController.text);
            },
            child: Text(
              AppLocalizations.of(context)!.done,
              style: textTheme.subtitle1?.copyWith(color: colorScheme.primary),
            )),
      ]);
    } else {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        MyExpandableText(text: myText),
        GestureDetector(
            onTap: () {
              setState(() {
                isEditing = true;
              });
            },
            child: Text(
              AppLocalizations.of(context)!.edit,
              style: textTheme.subtitle1?.copyWith(color: colorScheme.primary),
            )),
      ]);
    }
  }
}
