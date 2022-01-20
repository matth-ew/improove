import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubImproove extends StatelessWidget {
  const SubImproove({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.03,
            bottom: MediaQuery.of(context).size.height * 0.03),
        child: Text(AppLocalizations.of(context)!.sub_improove,
            style: const TextStyle(
                fontSize: 34,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
