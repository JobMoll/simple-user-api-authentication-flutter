import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          appBar: AppBar(
            backgroundColor: Colors.blue,
            leading: Container(),
            title: Text('Login'),
          ),
          body: SafeArea(
            child: Container(
              margin: EdgeInsets.only(top: 0, left: 12, right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // TODO wait for a solution from the Flutter team
                  AutofillGroup(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextField(
                            controller: usernameOrEmailTextfield,
                            focusNode: usernameOrEmailTextfieldNode,
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: [
                              AutofillHints.username,
                              AutofillHints.email
                            ],
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                            autocorrect: false,
                            cursorColor: Colors.white,
                            onEditingComplete: () {
                              FocusScope.of(context).unfocus();
                              passwordTextfieldNode.requestFocus();
                            },
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 17,
                                color: Colors.white70,
                              ),
                              hintText: 'Username or email',
                              suffixIcon: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(20),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 12),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextField(
                            controller: passwordTextfield,
                            focusNode: passwordTextfieldNode,
                            autofillHints: [AutofillHints.password],
                            obscureText: true,
                            cursorColor: Colors.white,
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 17,
                                color: Colors.white70,
                              ),
                              hintText: 'Password',
                              suffixIcon: Icon(
                                Icons.lock,
                                color: Colors.white,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (passwordTextfield.text != '' &&
                          usernameOrEmailTextfield.text != '') {
                        SimpleUserAPIAuthentication.showSimpleMessage(
                            'Checking if info is correct',
                            'One moment while we check you account...',
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
                    child: Container(
                      margin: EdgeInsets.only(top: 12),
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 65),
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed('/registerAccountPage');
                      },
                      child: Text(
                        'Create a new account',
                        style: TextStyle(fontSize: 17, color: Colors.black),
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
                        style: TextStyle(fontSize: 17, color: Colors.black),
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
