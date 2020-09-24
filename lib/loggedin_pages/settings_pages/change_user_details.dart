import 'package:flutter/material.dart';
import 'package:simple_user_api_authentication/global_widgets.dart';
import 'package:simple_user_api_authentication/simple_user_api_authentication_class.dart';

class ChangeUserDetailsPage extends StatefulWidget {
  ChangeUserDetailsPage({Key key}) : super(key: key);
  @override
  _ChangeUserDetailsPageState createState() => _ChangeUserDetailsPageState();
}

class _ChangeUserDetailsPageState extends State<ChangeUserDetailsPage> {
  TextEditingController firstnameTextfield = TextEditingController();
  TextEditingController lastnameTextfield = TextEditingController();
  TextEditingController emailTextfield = TextEditingController();
  TextEditingController passwordTextfield = TextEditingController();
  TextEditingController passwordConfirmTextfield = TextEditingController();

  FocusNode firstnameTextfieldNode = FocusNode();
  FocusNode lastnameTextfieldNode = FocusNode();
  FocusNode emailTextfieldNode = FocusNode();
  FocusNode passwordTextfieldNode = FocusNode();
  FocusNode passwordConfirmTextfieldNode = FocusNode();

  int minLength = 8;

  String passwordTipHasUppercase = 'Uppercases in your password';
  String passwordTipHasDigits = 'Digits in your password';
  String passwordTipHasLowercase = 'Lowercase in your password';
  String passwordTipHasSpecialCharacters =
      'Special Characters in your password';
  String passwordTipHasMinLength = 'Minimum password length of ';

  bool hasUppercase = false;
  bool hasDigits = false;
  bool hasLowercase = false;
  bool hasSpecialCharacters = false;
  bool hasMinLength = false;

  checkPasswordStrength(String password, int minLength) {
    if (password != null || password.isNotEmpty) {
      hasUppercase = password.contains(new RegExp(r'[A-Z]'));
      hasDigits = password.contains(new RegExp(r'[0-9]'));
      hasLowercase = password.contains(new RegExp(r'[a-z]'));
      hasSpecialCharacters =
          password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      hasMinLength = password.length > minLength;

      setState(() {});

      if (hasUppercase == true &&
          hasDigits == true &&
          hasLowercase == true &&
          hasSpecialCharacters == true &&
          hasMinLength == true) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: accentOppositeColor),
          backgroundColor: accentColor,
          title: Text(
            'Personal details',
            style: smallHeadingTextStyle.copyWith(color: accentOppositeColor),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 0, left: 12, right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            'Personal information',
                            style: smallHeadingTextStyle,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: 6),
                                child: SuaaGlobalTextfield(
                                  controller: firstnameTextfield,
                                  controllerNode: firstnameTextfieldNode,
                                  hintText: 'First name',
                                  icon: Icons.person,
                                  textInputType: TextInputType.name,
                                  autofillHints: [AutofillHints.givenName],
                                  functionOnEditingComplete: () {
                                    FocusScope.of(context)
                                        .requestFocus(lastnameTextfieldNode);
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 6),
                                child: SuaaGlobalTextfield(
                                  controller: lastnameTextfield,
                                  controllerNode: lastnameTextfieldNode,
                                  hintText: 'Last name',
                                  icon: Icons.person,
                                  textInputType: TextInputType.name,
                                  autofillHints: [AutofillHints.familyName],
                                  functionOnEditingComplete: () {
                                    FocusScope.of(context)
                                        .requestFocus(emailTextfieldNode);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SuaaGlobalTextfield(
                          controller: emailTextfield,
                          controllerNode: emailTextfieldNode,
                          hintText: 'Email',
                          icon: Icons.mail,
                          textInputType: TextInputType.emailAddress,
                          autofillHints: [AutofillHints.email],
                        ),
                        SuaaGlobalButton(
                          text: 'Change personal data',
                          functionOnTap: () {
                            if (passwordTextfield.text != '' &&
                                passwordConfirmTextfield.text != '' &&
                                passwordConfirmTextfield.text ==
                                    passwordTextfield.text) {
                              SimpleUserAPIAuthentication.showSimpleMessage(
                                  'Changing your password',
                                  'One moment while we change your password...',
                                  'info',
                                  100);

// TODO change user info call here
                              // SimpleUserAPIAuthentication.requestRefreshToken(
                              //     passwordConfirmTextfield.text,
                              //     passwordTextfield.text);
                            } else {
                              SimpleUserAPIAuthentication.showSimpleMessage(
                                  'The passwords are not the same',
                                  'The passwords you filled in are not the same...',
                                  'error',
                                  3);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            'Change your password',
                            style: smallHeadingTextStyle,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 12, bottom: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PasswordRequirements(
                                tip: passwordTipHasMinLength +
                                    minLength.toString(),
                                hasRequirement: hasMinLength,
                              ),
                              PasswordRequirements(
                                tip: passwordTipHasDigits,
                                hasRequirement: hasDigits,
                              ),
                              PasswordRequirements(
                                tip: passwordTipHasLowercase,
                                hasRequirement: hasLowercase,
                              ),
                              PasswordRequirements(
                                tip: passwordTipHasSpecialCharacters,
                                hasRequirement: hasSpecialCharacters,
                              ),
                              PasswordRequirements(
                                tip: passwordTipHasUppercase,
                                hasRequirement: hasUppercase,
                              ),
                            ],
                          ),
                        ),
                        SuaaGlobalTextfield(
                          controller: passwordTextfield,
                          controllerNode: passwordTextfieldNode,
                          hintText: 'New password',
                          icon: Icons.lock,
                          textInputType: TextInputType.text,
                          autofillHints: [AutofillHints.password],
                          obscureText: true,
                          functionOnChange: (string) {
                            checkPasswordStrength(string, minLength);
                          },
                          functionOnEditingComplete: () {
                            FocusScope.of(context)
                                .requestFocus(passwordConfirmTextfieldNode);
                          },
                        ),
                        SuaaGlobalTextfield(
                          controller: passwordConfirmTextfield,
                          controllerNode: passwordConfirmTextfieldNode,
                          hintText: 'Confirm new password',
                          icon: Icons.lock,
                          textInputType: TextInputType.text,
                          autofillHints: [AutofillHints.password],
                          obscureText: true,
                        ),
                        SuaaGlobalButton(
                          text: 'Change password',
                          functionOnTap: () {
                            if (passwordTextfield.text != '' &&
                                passwordConfirmTextfield.text != '' &&
                                passwordConfirmTextfield.text ==
                                    passwordTextfield.text) {
                              print(checkPasswordStrength(
                                  passwordTextfield.text, minLength));
                              if (checkPasswordStrength(
                                      passwordTextfield.text, minLength) ==
                                  true) {
                                SimpleUserAPIAuthentication.showSimpleMessage(
                                    'Changing your password',
                                    'One moment while we change your password...',
                                    'info',
                                    100);

                                SimpleUserAPIAuthentication.changePassword(
                                  passwordConfirmTextfield.text,
                                );

                                setState(() {
                                  passwordTextfield.text = '';
                                  passwordConfirmTextfield.text = '';
                                  hasUppercase = false;
                                  hasDigits = false;
                                  hasLowercase = false;
                                  hasSpecialCharacters = false;
                                  hasMinLength = false;
                                });
                              } else {
                                SimpleUserAPIAuthentication.showSimpleMessage(
                                    "Your password isn't strong enough",
                                    "Your password doesn't meet the requirements...",
                                    'error',
                                    3);
                              }
                            } else {
                              SimpleUserAPIAuthentication.showSimpleMessage(
                                  'The passwords are not the same',
                                  'The passwords you filled in are not the same...',
                                  'error',
                                  3);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordRequirements extends StatelessWidget {
  const PasswordRequirements({
    Key key,
    @required this.tip,
    this.minLength,
    @required this.hasRequirement,
  }) : super(key: key);

  final String tip;
  final int minLength;
  final bool hasRequirement;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          hasRequirement ? Icons.check : Icons.close,
          color: hasRequirement ? Colors.green : Colors.black,
          size: 20,
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          tip,
          style: TextStyle(color: hasRequirement ? Colors.green : Colors.black),
        ),
      ],
    );
  }
}
