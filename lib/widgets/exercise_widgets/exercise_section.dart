import 'package:flutter/material.dart';
import 'package:improove/widgets/edit_text.dart';
import 'package:improove/widgets/my_expandable_text.dart';

class ExerciseSection extends StatelessWidget {
  final String title;
  final List<String> textList;
  final Function onDone;
  final bool ifEdit;

  const ExerciseSection({
    Key? key,
    this.title = "",
    required this.textList,
    required this.onDone,
    required this.ifEdit,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Visibility(
      visible: textList.isNotEmpty,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 5, 25, 25),
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
            ...textList.map(
              (t) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Text(
                        "•",
                        style: textTheme.headline6?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        t,
                        style: textTheme.subtitle1?.copyWith(
                          color: colorScheme.primary.withOpacity(.59),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // MyExpandableText(text: text),
          ],
        ),
      ),
    );
  }
}
