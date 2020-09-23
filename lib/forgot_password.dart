import 'package:flutter/material.dart';
import 'package:simple_user_api_authentication/simple_user_api_authentication_class.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key key}) : super(key: key);
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController usernameOrEmailTextfield = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Forgot password'),
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
                    controller: usernameOrEmailTextfield,
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
                GestureDetector(
                  onTap: () {
                    if (usernameOrEmailTextfield.text != '') {
                      SimpleUserAPIAuthentication.showSimpleMessage(
                          'One moment while we prepare your url',
                          'We are preparing your reset url...',
                          'info',
                          100);

                      SimpleUserAPIAuthentication.forgotPassword(
                        usernameOrEmailTextfield.text,
                      );

                      setState(() {
                        usernameOrEmailTextfield.text = '';
                      });
                    } else {
                      SimpleUserAPIAuthentication.showSimpleMessage(
                          "You can't leave this field empty",
                          'You forgot to fill in  the field...',
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
                        'Create new password',
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
