import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:improove/services/authservice.dart';
import 'authentication_widgets/login_form.dart';
import 'authentication_widgets/signup_form.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool signIn = true;

  Future<void> _facebookLogin() async {
    try {
      final LoginResult result = await FacebookAuth.instance
          .login(); // by default we request the email and the public profile
// or FacebookAuth.i.login()
      debugPrint(
          "PRE LOGIN ${result.message} ${result.status.toString()} ${result.accessToken.toString()}");
      if (result.status == LoginStatus.success) {
        // you are logged
        final AccessToken accessToken = result.accessToken!;
        debugPrint("LOGIN " + accessToken.toString());
        AuthService().loginFacebook(accessToken).then((val) {
          final String? token = val?.data['token'] as String?;
          final String? msg = val?.data['msg'] as String?;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Processing Data Facebook: $msg - $token'),
            ),
          );
        });
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> _googleLogin() async {
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
          print(googleKey.accessToken);
          if (googleKey.accessToken != null) {
            AuthService().loginGoogle(googleKey.accessToken!).then((val) {
              final String? token = val?.data['token'] as String?;
              final String? msg = val?.data['msg'] as String?;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Processing Data Google: $msg - $token'),
                ),
              );
            });
          }
        });
      });
    } catch (error) {
      print(error);
    }
  }

  _appleLogin() async {}

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // final buttonTheme = Theme.of(context).buttonTheme;
    final textTheme = Theme.of(context).textTheme;
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
                        signIn ? "- or sign in with -" : "- or sign up with -",
                        style: textTheme.overline?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _facebookLogin,
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.fromLTRB(15, 10, 15, 10)),
                            backgroundColor: MaterialStateProperty.all<Color>(
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
                          onPressed: _googleLogin,
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.fromLTRB(15, 10, 15, 10)),
                            backgroundColor: MaterialStateProperty.all<Color>(
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
  }
}
