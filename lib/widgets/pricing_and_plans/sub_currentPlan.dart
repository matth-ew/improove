import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class sub_currentPlan extends StatefulWidget {
  final int selectedPlan;

  const sub_currentPlan({Key? key, required this.selectedPlan})
      : super(key: key);

  @override
  _sub_currentPlan createState() => _sub_currentPlan();
}

class _sub_currentPlan extends State<sub_currentPlan> {
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                (widget.selectedPlan == 0
                        ? AppLocalizations.of(context)!.sub_one
                        : (widget.selectedPlan == 1
                            ? AppLocalizations.of(context)!.sub_three
                            : AppLocalizations.of(context)!.sub_six)) +
                    " - ",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            Text(
                (widget.selectedPlan == 0
                    ? AppLocalizations.of(context)!.sub_one_price
                    : (widget.selectedPlan == 1
                        ? AppLocalizations.of(context)!.sub_three_price
                        : AppLocalizations.of(context)!.sub_six_price)),
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
