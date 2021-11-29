import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FolderNameDialog extends StatefulWidget {
  final Function? onSubmit;

  const FolderNameDialog({
    Key? key,
    this.onSubmit,
  }) : super(key: key);

  @override
  State<FolderNameDialog> createState() => _FolderNameDialogState();
}

class _FolderNameDialogState extends State<FolderNameDialog> {
  String currentText = "";

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;
    // final buttonTheme = Theme.of(context).buttonTheme;
    // final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Text(
          //   "Folder Name",
          //   style: textTheme.headline6?.copyWith(
          //       fontWeight: FontWeight.w600, color: colorScheme.primary),
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 30.0),
            child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  // labelText: 'Email',
                  hintText: AppLocalizations.of(context)!.folderName,
                ),
                onSubmitted: (v) {
                  widget.onSubmit?.call(
                    v,
                    (String? e) {
                      Navigator.of(context).pop();
                    },
                  );
                },
                onChanged: (value) {
                  setState(() {
                    currentText = value;
                  });
                }),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onSubmit?.call(
                currentText,
                (String? e) {
                  Navigator.of(context).pop();
                },
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: const StadiumBorder(),
            ),
            child: Text(
              AppLocalizations.of(context)!.createFolder,
              // style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
