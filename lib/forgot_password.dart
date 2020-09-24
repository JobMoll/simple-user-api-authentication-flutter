import 'package:flutter/material.dart';
import 'package:simple_user_api_authentication/global_widgets.dart';
import 'package:simple_user_api_authentication/simple_user_api_authentication_class.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key key}) : super(key: key);
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController usernameOrEmailTextfield = TextEditingController();
  FocusNode usernameOrEmailTextfieldNode = FocusNode();

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
            'Forgot password',
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
                  controller: usernameOrEmailTextfield,
                  controllerNode: usernameOrEmailTextfieldNode,
                  hintText: 'Username or email',
                  icon: Icons.email,
                  textInputType: TextInputType.emailAddress,
                  autofillHints: [AutofillHints.email, AutofillHints.username],
                ),
                SuaaGlobalButton(
                  text: 'Create a new password',
                  functionOnTap: () {
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
