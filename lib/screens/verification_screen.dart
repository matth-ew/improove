import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:improove/redux/actions/user.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/screens/nav_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:redux/redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerificationScreen extends StatefulWidget {
  final int? verifyToken;
  const VerificationScreen({
    Key? key,
    this.verifyToken,
  }) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  TextEditingController textEditingController = TextEditingController();

  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>.broadcast();
    super.initState();
  }

  @override
  void dispose() {
    errorController?.close();

    super.dispose();
  }

  Future<void> _verify(Function thunkAction, int? value) async {
    try {
      thunkAction(
        value,
        (String? e) {
          if (e == null) {
            debugPrint("NOT ERROR");
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const NavScreen(),
              ),
            );
          } else {
            debugPrint("ERROR ${e.toString()}");
            errorController?.add(ErrorAnimationType.shake);
            setState(() {
              hasError = true;
            });
          }
        },
      );
      // .then((val) {
      //   final String? token = val?.data['token'] as String?;
      //   final String? msg = val?.data['msg'] as String?;
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Processing Data Facebook: $msg - $token'),
      //     ),
      //   );
      // });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // final buttonTheme = Theme.of(context).buttonTheme;
    final textTheme = Theme.of(context).textTheme;
    const height = 44.0;
    const fontSize = height * 0.40;
    return StoreConnector(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {
        return Scaffold(
          // appBar: AppBar(title: Text('Verification')),
          backgroundColor: colorScheme.background,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.verification,
                      style: textTheme.headline6?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    Column(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/verification.svg',
                          width: 300,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Text(
                            AppLocalizations.of(context)!.verificationCode,
                            style: textTheme.headline5?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Text(
                            AppLocalizations.of(context)!.verifEmailSent,
                            style: textTheme.bodyText2?.copyWith(
                              color: colorScheme.primary,
                              // fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          length: 5,
                          obscureText: false,
                          // obscuringCharacter: '*',
                          // obscuringWidget: FlutterLogo(
                          //   size: 24,
                          // ),
                          blinkWhenObscuring: true,
                          animationType: AnimationType.fade,
                          validator: (v) {
                            if (hasError) {
                              return "Invalid code";
                            } else {
                              return null;
                            }
                          },
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(15),
                            fieldHeight: 60,
                            fieldWidth: 60,
                            activeFillColor: colorScheme.primary.withAlpha(10),
                            inactiveFillColor:
                                colorScheme.primary.withAlpha(10),
                            selectedFillColor:
                                colorScheme.primary.withAlpha(10),
                            activeColor: colorScheme.primary.withOpacity(0.5),
                            selectedColor: colorScheme.primary,
                            inactiveColor: colorScheme.primary.withOpacity(0.4),
                          ),
                          cursorColor: Colors.black,
                          animationDuration: const Duration(milliseconds: 300),
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: textEditingController,
                          keyboardType: TextInputType.number,
                          // boxShadows: [
                          //   BoxShadow(
                          //     offset: Offset(0, 1),
                          //     color: Colors.black12,
                          //     blurRadius: 10,
                          //   )
                          // ],
                          onCompleted: (v) {
                            _verify(vm.verify, int.tryParse(v));
                          },
                          // onTap: () {
                          //   print("Pressed");
                          // },
                          onChanged: (value) {
                            setState(() {
                              currentText = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            debugPrint("Allowing to paste $text");
                            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                            //but you can show anything you want here, like your pop up saying wrong paste format or etc
                            return true;
                          },
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.zero),
                    Column(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            // vm.verify(1234);
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            shape: const StadiumBorder(),
                            primary: colorScheme.primary,
                            onSurface: colorScheme.primary,
                            shadowColor: colorScheme.primary,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.resend,
                            style: const TextStyle(fontSize: fontSize),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(8)),
                        ElevatedButton(
                          onPressed: () {
                            _verify(vm.verify, int.tryParse(currentText));
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            shape: const StadiumBorder(),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.submitVerification,
                            style: const TextStyle(fontSize: fontSize),
                          ),
                        ),
                      ],
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
  final Function(int? verifyToken, [Function? cb]) verify;
  final Function([Function? cb]) resendVerificationToken;

  _ViewModel({
    required this.user,
    required this.verify,
    required this.resendVerificationToken,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      user: store.state.user,
      verify: (verifyToken, [cb]) =>
          store.dispatch(verifyThunk(verifyToken, cb)),
      resendVerificationToken: ([cb]) =>
          store.dispatch(resendVerificationThunk(cb)),
    );
  }
}
