import 'package:flutter/material.dart';
import 'package:simple_user_api_authentication/simple_user_api_authentication_class.dart';

class RegisterAccountPage extends StatefulWidget {
  RegisterAccountPage({Key key}) : super(key: key);
  @override
  _RegisterAccountPagePageState createState() =>
      _RegisterAccountPagePageState();
}

class _RegisterAccountPagePageState extends State<RegisterAccountPage> {
  TextEditingController usernameTextfield = TextEditingController();
  TextEditingController emailTextfield = TextEditingController();

  FocusNode usernameTextfieldNode = FocusNode();
  FocusNode emailTextfieldNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Register account'),
        ),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 0, left: 12, right: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    controller: usernameTextfield,
                    focusNode: usernameTextfieldNode,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                    autocorrect: false,
                    cursorColor: Colors.white,
                    onEditingComplete: () {
                      emailTextfieldNode.requestFocus();
                    },
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 17,
                        color: Colors.white70,
                      ),
                      hintText: 'Username',
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
                    controller: emailTextfield,
                    focusNode: emailTextfieldNode,
                    autofillHints: [AutofillHints.email],
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 17,
                        color: Colors.white70,
                      ),
                      hintText: 'Email',
                      suffixIcon: Icon(
                        Icons.mail,
                        color: Colors.white,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(20),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (usernameTextfield.text != '' &&
                        emailTextfield.text != '') {
                      SimpleUserAPIAuthentication.showSimpleMessage(
                          'Trying to register',
                          'We are trying to register your new account...',
                          'info',
                          100);

                      if (usernameTextfield.text.contains(' ')) {
                        SimpleUserAPIAuthentication.showSimpleMessage(
                            'Username is not valid :(',
                            "A username can't have spaces in it...",
                            'error',
                            3);
                        return;
                      }

                      SimpleUserAPIAuthentication.registerNewUser(
                          usernameTextfield.text, emailTextfield.text);

                      setState(() {
                        usernameTextfield.text = '';
                        emailTextfield.text = '';
                      });
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
                        'Create a new account',
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
