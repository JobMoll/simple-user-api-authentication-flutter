import 'package:flutter/material.dart';
import 'package:simple_user_api_authentication/simple_user_api_authentication_class.dart';

class LoggedinOrNotPage extends StatefulWidget {
  LoggedinOrNotPage({Key key}) : super(key: key);
  @override
  _LoggedinOrNotPageState createState() => _LoggedinOrNotPageState();
}

class _LoggedinOrNotPageState extends State<LoggedinOrNotPage> {
// cheat sheet for shared preferences
// https://medium.com/flutterdevs/using-sharedpreferences-in-flutter-251755f07127

  @override
  void initState() {
    super.initState();
    SimpleUserAPIAuthentication.checkForValidRefreshToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Loading...'),
          ],
        ),
      ),
    );
  }
}
