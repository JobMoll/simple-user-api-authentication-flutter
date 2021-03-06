import 'package:flutter/material.dart';
import 'package:simple_user_api_authentication/global/global_widgets.dart';
import 'package:simple_user_api_authentication/global/simple_user_api_authentication_class.dart';

class LoggedinOrNotPage extends StatefulWidget {
  LoggedinOrNotPage({Key key}) : super(key: key);
  @override
  _LoggedinOrNotPageState createState() => _LoggedinOrNotPageState();
}

class _LoggedinOrNotPageState extends State<LoggedinOrNotPage> {
  @override
  void initState() {
    super.initState();
    SUAAAuth.checkForValidRefreshToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: Center(
          child: Container(),
        ),
      ),
    );
  }
}
