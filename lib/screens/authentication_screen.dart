import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:improove/redux/actions/user.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/screens/nav_screen.dart';
import 'package:redux/redux.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'authentication_widgets/login_form.dart';
import 'authentication_widgets/signup_form.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool signIn = true;

  Future<void> _facebookLogin(Function thunkAction, [Function? cb]) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        // you are logged
        final AccessToken accessToken = result.accessToken!;
        debugPrint("LOGIN ${accessToken.token}");
        thunkAction(accessToken.token, cb);
        // .then((val) {
        //   final String? token = val?.data['token'] as String?;
        //   final String? msg = val?.data['msg'] as String?;
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text('Processing Data Facebook: $msg - $token'),
        //     ),
        //   );
        // });
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> _googleLogin(Function thunkAction, [Function? cb]) async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'profile',
          'email',
          // 'https://www.googleapis.com/auth/user.birthday.read',
          // 'https://www.googleapis.com/auth/user.gender.read',
        ],
      );
      await _googleSignIn.signIn().then((result) {
        result?.authentication.then((googleKey) {
          if (googleKey.accessToken != null) {
            thunkAction(googleKey.accessToken!, cb);
            // .then((val) {
            //   final String? token = val?.data['token'] as String?;
            //   final String? msg = val?.data['msg'] as String?;
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(
            //       content: Text('Processing Data Google: $msg - $token'),
            //     ),
            //   );
            // });
          }
        });
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> _appleLogin(Function thunkAction, [Function? cb]) async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
          clientId: 'fit.improove',
          redirectUri: Uri.parse(
            'https://improove.fit/api/redirect-apple',
          ),
        ),
      );

      debugPrint("APPLE CRED: ${credential.authorizationCode}");
      thunkAction(credential.authorizationCode, cb);
    } catch (error) {
      debugPrint(error.toString());
    }

    // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
    // after they have been validated with Apple (see `Integration` section for more information on how to do this)
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // final buttonTheme = Theme.of(context).buttonTheme;
    final textTheme = Theme.of(context).textTheme;
    return StoreConnector(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {
        return Scaffold(
          backgroundColor: colorScheme.background,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                      child: Text(
                        "Improove",
                        style: textTheme.headline3?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    if (signIn) LoginForm() else SignupForm(),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            signIn
                                ? "- or sign in with -"
                                : "- or sign up with -",
                            style: textTheme.overline?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: SignInWithAppleButton(
                            onPressed: () => _appleLogin(
                              vm.appleLogin,
                              (String? e) {
                                if (e == null) {
                                  debugPrint("NOT ERROR");
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => NavScreen(),
                                    ),
                                  );
                                } else {
                                  debugPrint("ERROR ${e.toString()}");
                                }
                              },
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () => _facebookLogin(
                                vm.facebookLogin,
                                (String? e) {
                                  if (e == null) {
                                    debugPrint("NOT ERROR");
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) => NavScreen(),
                                      ),
                                    );
                                  } else {
                                    debugPrint("ERROR ${e.toString()}");
                                  }
                                },
                              ),
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.fromLTRB(15, 10, 15, 10)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        colorScheme.background),
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/facebook.svg',
                                height: 24,
                              ),
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            ElevatedButton(
                              onPressed: () => _googleLogin(
                                vm.googleLogin,
                                (String? e) {
                                  if (e == null) {
                                    debugPrint("NOT ERROR");
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) => NavScreen(),
                                      ),
                                    );
                                  } else {
                                    debugPrint("ERROR ${e.toString()}");
                                  }
                                },
                              ),
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.fromLTRB(15, 10, 15, 10)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        colorScheme.background),
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/google.svg',
                                height: 24,
                              ),
                            ),
                            // ElevatedButton(
                            //   onPressed: _appleLogin,
                            //   child: SvgPicture.asset('assets/icons/apple.svg'),
                            // ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            signIn
                                ? "Don't have an account? "
                                : "Already have an account? ",
                            style: textTheme.overline?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                signIn = !signIn;
                              });
                            },
                            child: Text(
                              signIn ? "Sign up" : "Sign in",
                              style: textTheme.overline?.copyWith(
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel {
  final User user;
  final Function(String accessToken, [Function? cb]) facebookLogin;
  final Function(String accessToken, [Function? cb]) googleLogin;
  final Function(String accessToken, [Function? cb]) appleLogin;

  _ViewModel({
    required this.user,
    required this.googleLogin,
    required this.facebookLogin,
    required this.appleLogin,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      user: store.state.user,
      facebookLogin: (token, [cb]) =>
          store.dispatch(loginFacebookThunk(token, cb)),
      googleLogin: (token, [cb]) => store.dispatch(loginGoogleThunk(token, cb)),
      appleLogin: (token, [cb]) => store.dispatch(loginAppleThunk(token, cb)),
    );
  }
}
