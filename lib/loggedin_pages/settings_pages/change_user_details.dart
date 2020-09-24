import 'package:flutter/material.dart';
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
        appBar: AppBar(
          title: Text('Personal details'),
        ),
        body: SafeArea(
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
                        margin: EdgeInsets.only(bottom: 12),
                        child: Text(
                          'Personal information',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextField(
                                controller: firstnameTextfield,
                                focusNode: firstnameTextfieldNode,
                                autofillHints: [
                                  AutofillHints.givenName,
                                ],
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                                autocorrect: false,
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white70,
                                  ),
                                  hintText: 'First name',
                                  suffixIcon: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(20),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextField(
                                controller: lastnameTextfield,
                                focusNode: lastnameTextfieldNode,
                                autofillHints: [
                                  AutofillHints.familyName,
                                ],
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                                autocorrect: false,
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white70,
                                  ),
                                  hintText: 'Last name',
                                  suffixIcon: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextField(
                          controller: emailTextfield,
                          focusNode: emailTextfieldNode,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: [
                            AutofillHints.email,
                          ],
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                          autocorrect: false,
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: 17,
                              color: Colors.white70,
                            ),
                            hintText: 'Email',
                            suffixIcon: Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(20),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
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
                        child: Container(
                          margin: EdgeInsets.only(top: 12),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'Change personal details',
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        ),
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
                          style: TextStyle(fontSize: 18),
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
                          obscureText: true,
                          autofillHints: [
                            AutofillHints.newPassword,
                          ],
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                          autocorrect: false,
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: 17,
                              color: Colors.white70,
                            ),
                            hintText: 'New password',
                            suffixIcon: Icon(
                              Icons.lock,
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
                          controller: passwordConfirmTextfield,
                          focusNode: passwordConfirmTextfieldNode,
                          obscureText: true,
                          autofillHints: [
                            AutofillHints.newPassword,
                          ],
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                          autocorrect: false,
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: 17,
                              color: Colors.white70,
                            ),
                            hintText: 'New password confirm',
                            suffixIcon: Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(20),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (passwordTextfield.text != '' &&
                              passwordConfirmTextfield.text != '' &&
                              passwordConfirmTextfield.text ==
                                  passwordTextfield.text) {
                            SimpleUserAPIAuthentication.showSimpleMessage(
                                'Changing your password',
                                'One moment while we change your password...',
                                'info',
                                100);

// TODO password reset call here
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
                        child: Container(
                          margin: EdgeInsets.only(top: 12),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'Change password',
                            style: TextStyle(fontSize: 17, color: Colors.white),
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
