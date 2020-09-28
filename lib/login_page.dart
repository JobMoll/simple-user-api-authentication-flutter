import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_user_api_authentication/global_widgets.dart';
import 'package:simple_user_api_authentication/simple_user_api_authentication_class.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameOrEmailTextfield = TextEditingController();
  TextEditingController passwordTextfield = TextEditingController();

  FocusNode usernameOrEmailTextfieldNode = FocusNode();
  FocusNode passwordTextfieldNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          backgroundColor: mainColor,
          appBar: AppBar(
            iconTheme: IconThemeData(color: accentOppositeColor),
            backgroundColor: accentColor,
            leading: Container(),
            title: Text(
              'Login',
              style: smallHeadingTextStyle.copyWith(color: accentOppositeColor),
            ),
          ),
          body: SafeArea(
            child: Container(
              margin: EdgeInsets.only(top: 0, left: 12, right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AutofillGroup(
                    child: Column(
                      children: [
                        SuaaGlobalTextfield(
                          controller: usernameOrEmailTextfield,
                          controllerNode: usernameOrEmailTextfieldNode,
                          hintText: 'Username or email',
                          icon: Icons.email,
                          textInputType: TextInputType.emailAddress,
                          autofillHints: [
                            AutofillHints.email,
                            AutofillHints.username
                          ],
                          functionOnEditingComplete: () {
                            FocusScope.of(context)
                                .requestFocus(passwordTextfieldNode);
                          },
                        ),
                        SuaaGlobalTextfield(
                          controller: passwordTextfield,
                          controllerNode: passwordTextfieldNode,
                          hintText: 'Password',
                          icon: Icons.lock,
                          textInputType: TextInputType.text,
                          autofillHints: [AutofillHints.password],
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                  SuaaGlobalButton(
                    text: 'Login',
                    functionOnTap: () {
                      if (passwordTextfield.text != '' &&
                          usernameOrEmailTextfield.text != '') {
                        SimpleUserAPIAuthentication.showSimpleMessage(
                            'Checking if login credentials are correct',
                            'One moment while we check your account...',
                            'info',
                            100);

                        SimpleUserAPIAuthentication.requestRefreshToken(
                            usernameOrEmailTextfield.text,
                            passwordTextfield.text);
                      } else {
                        SimpleUserAPIAuthentication.showSimpleMessage(
                            'Fill in all required fields',
                            'You forgot to fill in one of the fields...',
                            'error',
                            3);
                      }
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 65),
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed('/registerAccountPage');
                      },
                      child: Text(
                        'Create a new account',
                        style: bodyTextStyle,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 9),
                    child: Divider(
                      color: Colors.black38,
                    ),
                  ),
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed('/forgotPasswordPage');
                      },
                      child: Text(
                        'I forgot my password',
                        style: bodyTextStyle,
                      ),
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
