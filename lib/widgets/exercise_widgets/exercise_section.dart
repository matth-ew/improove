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
    required this.title,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 25.0,
              right: 25.0,
              bottom: 10.0,
            ),
            child: Text(
              title,
              style: textTheme.headline6?.copyWith(color: colorScheme.primary),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 25.0,
              right: 25.0,
              bottom: 15.0,
            ),
            child: EditTextCard(
              text: text,
              onDone: onDone,
            ),
          ),
        ],
      ),
      replacement: Visibility(
        visible: text.isNotEmpty,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 25.0,
                right: 25.0,
                bottom: 10.0,
              ),
              child: Text(
                title,
                style:
                    textTheme.headline6?.copyWith(color: colorScheme.primary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 25.0,
                right: 25.0,
                bottom: 15.0,
              ),
              child: MyExpandableText(text: text),
            ),
          ],
        ),
      ),
    );
  }
}
