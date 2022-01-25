import 'package:flutter/material.dart';
import 'package:improove/widgets/edit_text.dart';
import 'package:improove/widgets/my_expandable_text.dart';

class ExerciseSection extends StatelessWidget {
  final String title;
  final String text;
  final Function onDone;
  final bool ifEdit;

  const ExerciseSection({
    Key? key,
    this.title = "",
    required this.text,
    required this.onDone,
    required this.ifEdit,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Visibility(
      visible: ifEdit,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: title.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 15.0,
                ),
                child: Text(
                  title,
                  style:
                      textTheme.headline6?.copyWith(color: colorScheme.primary),
                ),
              ),
            ),
            EditTextCard(
              text: text,
              onDone: onDone,
            ),
          ],
        ),
      ),
      replacement: Visibility(
        visible: text.isNotEmpty,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: title.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 15.0,
                  ),
                  child: Text(
                    title,
                    style: textTheme.headline6
                        ?.copyWith(color: colorScheme.primary),
                  ),
                ),
              ),
              MyExpandableText(text: text),
            ],
          ),
        ),
      ),
    );
  }
}
