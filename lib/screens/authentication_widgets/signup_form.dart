import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/actions/user.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/screens/webview_screen.dart';
import 'package:improove/screens/verification_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignupForm extends StatefulWidget {
  final double? fontSize;

  const SignupForm({
    Key? key,
    this.fontSize = 24,
  }) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  final _formEmailKey = GlobalKey<FormFieldState>();
  final _emailController = TextEditingController();

  final _formPasswordKey = GlobalKey<FormFieldState>();
  final _passwordController = TextEditingController();

  final _formCPasswordKey = GlobalKey<FormFieldState>();

  bool _obscurePassword = true;
  bool _obscureCPassword = true;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? validateEmail(String? value) {
    final RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (value == null || !regex.hasMatch(value)) {
      return 'Enter a valid email address';
    } else {
      return null;
    }
  }

  String? validatePassword(String? value) {
    const Pattern pattern = r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d!@#$%^&*]{8,}$";
    final RegExp regex = RegExp(pattern.toString());
    if (value == null || !regex.hasMatch(value)) {
      return 'Your password must be at least 8 characters long, contain at least one number and one letter.';
    } else {
      return null;
    }
  }

  String? validateCPassword(String? value) {
    if (value != _formPasswordKey.currentState?.value) {
      return 'Password confirmation does not match.';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // final buttonTheme = Theme.of(context).buttonTheme;
    final textTheme = Theme.of(context).textTheme;
    final focus = FocusNode();
    return StoreConnector(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15),
              child: Text(
                AppLocalizations.of(context)!.createAccount,
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
                      key: _formEmailKey,
                      controller: _emailController,
                      onFieldSubmitted: (value) {
                        _formEmailKey.currentState?.validate();
                      },
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail,
                      decoration: InputDecoration(
                        errorMaxLines: 2,
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        // labelText: 'Email',
                        hintText: 'Email',
                        // prefixIcon: Padding(
                        //   padding: const EdgeInsets.only(left: 10),
                        //   child: Icon(Icons.email),
                        // ),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: TextFormField(
                      key: _formPasswordKey,
                      controller: _passwordController,
                      onFieldSubmitted: (value) {
                        bool val =
                            _formPasswordKey.currentState?.validate() ?? false;
                        if (val) {
                          FocusScope.of(context).requestFocus(focus);
                        }
                      },
                      validator: validatePassword,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        errorMaxLines: 2,
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                        // prefixIcon: Icon(Icons.lock),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: TextFormField(
                      focusNode: focus,
                      key: _formCPasswordKey,
                      onFieldSubmitted: (value) {
                        _formCPasswordKey.currentState?.validate();
                      },
                      validator: validateCPassword,
                      obscureText: _obscureCPassword,
                      decoration: InputDecoration(
                        errorMaxLines: 2,
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        // labelText: 'Confirm Password',
                        hintText: 'Confirm Password',
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: IconButton(
                            splashRadius: 20,
                            icon: Icon(_obscureCPassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(
                                () {
                                  _obscureCPassword = !_obscureCPassword;
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
                    padding: const EdgeInsets.only(
                        top: 15.0, bottom: 10, left: 20, right: 20),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: textTheme.overline,
                        children: [
                          TextSpan(
                            text: "${AppLocalizations.of(context)!.legalText} ",
                          ),
                          TextSpan(
                            text: AppLocalizations.of(context)!.termsConditions,
                            style: const TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                pushNewScreen(
                                  context,
                                  screen: const WebViewScreen(
                                      url: "https://improove.fit/terms"),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                );
                              },
                          ),
                          TextSpan(
                            text: ' ${AppLocalizations.of(context)!.and} ',
                          ),
                          TextSpan(
                            text: AppLocalizations.of(context)!.privacyPolicy,
                            style: const TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                pushNewScreen(
                                  context,
                                  screen: const WebViewScreen(
                                      url: "https://improove.fit/privacy"),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        vm.signup(
                          _emailController.text,
                          _passwordController.text,
                          (String? e) {
                            if (e == null) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const VerificationScreen(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Processing Data: $e'),
                                    behavior: SnackBarBehavior.floating),
                              );
                            }
                          },
                        );
                        // AuthService()
                        //     .addUser(
                        //   _emailController.text,
                        //   _passwordController.text,
                        // )
                        //     .then(
                        //   (val) {
                        //     if (val?.data['success'] as bool) {
                        //       final token = val?.data['token'];
                        //       ScaffoldMessenger.of(context).showSnackBar(
                        //         SnackBar(
                        //           content: Text(
                        //               'Processing Data: ${_emailController.text} ${_passwordController.text} $token'),
                        //         ),
                        //       );
                        //     } else {
                        //       ScaffoldMessenger.of(context).showSnackBar(
                        //         SnackBar(
                        //           content: Text(
                        //               'Processing Data: ${_emailController.text} ${_passwordController.text} ${val?.data['msg']}'),
                        //         ),
                        //       );
                        //     }
                        //   },
                        // );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.signup,
                      style: TextStyle(fontSize: widget.fontSize),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ViewModel {
  final User user;
  final Function(String email, String password, [Function? cb]) signup;

  _ViewModel({
    required this.user,
    required this.signup,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      user: store.state.user,
      signup: (email, password, [cb]) => store.dispatch(
        signupThunk(email, password, cb),
      ),
    );
  }
}
