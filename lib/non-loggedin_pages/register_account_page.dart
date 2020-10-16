import 'package:flutter/material.dart';
import 'package:simple_user_api_authentication/global/global_widgets.dart';
import 'package:simple_user_api_authentication/global/simple_user_api_authentication_class.dart';

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
        backgroundColor: mainColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: accentOppositeColor),
          backgroundColor: accentColor,
          title: Text(
            'Register account',
            style: smallHeadingTextStyle.copyWith(color: accentOppositeColor),
          ),
        ),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 0, left: 12, right: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SuaaGlobalTextfield(
                  controller: usernameTextfield,
                  controllerNode: usernameTextfieldNode,
                  hintText: 'Username',
                  icon: Icons.person,
                  textInputType: TextInputType.text,
                  autofillHints: [AutofillHints.username],
                  functionOnEditingComplete: () {
                    FocusScope.of(context).requestFocus(emailTextfieldNode);
                  },
                ),
                SuaaGlobalTextfield(
                  controller: emailTextfield,
                  controllerNode: emailTextfieldNode,
                  hintText: 'Email',
                  icon: Icons.email,
                  textInputType: TextInputType.emailAddress,
                  autofillHints: [AutofillHints.email],
                ),
                SuaaGlobalButton(
                  text: 'Create a new account',
                  functionOnTap: () {
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
