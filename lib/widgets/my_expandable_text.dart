import 'package:flutter/material.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyExpandableText extends StatelessWidget {
  final String text;

  const MyExpandableText({Key? key, this.text = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ExpandableText(text,
        expandText: AppLocalizations.of(context)!.show,
        collapseText: AppLocalizations.of(context)!.hide,
        linkColor: colorScheme.primary,
        maxLines: 6,
        style: textTheme.subtitle1
            ?.copyWith(color: colorScheme.primary.withOpacity(.59)));
  }
}
