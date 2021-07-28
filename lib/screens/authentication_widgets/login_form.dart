import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  String? validateEmail(String? value) {
    const Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    final RegExp regex = RegExp(pattern.toString());
    if (value == null || !regex.hasMatch(value)) {
      return 'Enter a valid email address';
    } else {
      return null;
    }
  }

  String? validatePassword(String? value) {
    const Pattern pattern = r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$";
    final RegExp regex = RegExp(pattern.toString());
    if (value == null || !regex.hasMatch(value)) {
      return 'Your password must be at least 8 characters long, contain at least one number and one letter.';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // final buttonTheme = Theme.of(context).buttonTheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 15),
          child: Text(
            "Login to your account",
            textAlign: TextAlign.left,
            style: textTheme.headline6?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ),
        Form(
          key: _formKey,
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: TextFormField(
                  controller: _emailController,
                  validator: validateEmail,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    // labelText: 'Email',
                    hintText: 'Email',
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: TextFormField(
                  controller: _passwordController,
                  validator: validatePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    // labelText: 'Password',
                    hintText: 'Password',
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: IconButton(
                        splashRadius: 20,
                        icon: Icon(_obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(
                            () {
                              _obscurePassword = !_obscurePassword;
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Processing Data: ${_emailController.text} ${_passwordController.text}')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Sign In'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
