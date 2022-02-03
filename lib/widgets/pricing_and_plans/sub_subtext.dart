import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:improove/redux/models/improove_purchases.dart';

class SubSubtext extends StatelessWidget {
  const SubSubtext({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Text(
              AppLocalizations.of(context)!.sub_subtext,
              style: const TextStyle(
                  letterSpacing: 0.5,
                  color: Colors.grey,
                  fontWeight: FontWeight.w800,
                  fontSize: 16),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
