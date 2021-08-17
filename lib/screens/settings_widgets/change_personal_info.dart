import 'package:flutter/material.dart';

class ChangePersonalInfo extends StatefulWidget {
  final String? name;
  final String? surname;
  final Function? submit;

  const ChangePersonalInfo({
    Key? key,
    required this.name,
    required this.surname,
    required this.submit,
  }) : super(key: key);

  @override
  @override
  _ChangePersonalInfoState createState() => _ChangePersonalInfoState();
}

class _ChangePersonalInfoState extends State<ChangePersonalInfo> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();

  String? validateText(String? value) {
    final RegExp regex = RegExp(r'^[^\d]+$');
    if (value == null || !regex.hasMatch(value)) {
      return 'Enter a valid text';
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.value = _nameController.value.copyWith(text: widget.name);
    _surnameController.value =
        _surnameController.value.copyWith(text: widget.surname);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // final buttonTheme = Theme.of(context).buttonTheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Change personal info",
          style: textTheme.headline6?.copyWith(
              color: colorScheme.primary, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          splashRadius: 25,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close, color: colorScheme.onSurface),
        ),
        actions: [
          IconButton(
            splashRadius: 25,
            onPressed: () {
              final String? name = _nameController.text;
              final String? surname = _surnameController.text;
              if (validateText(name) == null && validateText(surname) == null) {
                if (name != widget.name || surname != widget.surname) {
                  widget.submit?.call(
                    _nameController.text,
                    _surnameController.text,
                    (String? e) {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  );
                } else {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              }
            },
            icon: Icon(Icons.done, color: colorScheme.secondary),
          ),
        ],
        backgroundColor: colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: TextFormField(
                  // key: _formEmailKey,
                  controller: _nameController,
                  onFieldSubmitted: (value) {
                    // _formEmailKey.currentState?.validate();
                  },
                  keyboardType: TextInputType.name,
                  validator: validateText,
                  decoration: InputDecoration(
                    errorMaxLines: 2,
                    contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    labelText: 'Name',
                  ),
                  textInputAction: TextInputAction.done,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: TextFormField(
                  // key: _formEmailKey,
                  controller: _surnameController,
                  onFieldSubmitted: (value) {
                    // _formEmailKey.currentState?.validate();
                  },
                  keyboardType: TextInputType.text,
                  validator: validateText,
                  decoration: InputDecoration(
                    errorMaxLines: 2,
                    contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    labelText: 'Surname',
                  ),
                  textInputAction: TextInputAction.done,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
