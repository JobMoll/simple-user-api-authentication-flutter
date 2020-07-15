import 'package:flutter/material.dart';
import 'package:simple_user_api_authentication/simple_user_api_authentication_class.dart';

class InformationPage extends StatefulWidget {
  final String accessToken;
  InformationPage({Key key, this.accessToken}) : super(key: key);
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
// cheat sheet for shared preferences

  @override
  void initState() {
    super.initState();
    accessTokenOnPage = widget.accessToken;
    SimpleUserAPIAuthentication.getUserData(accessTokenOnPage, false);
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
            Text('Information page'),
            FlatButton(
              onPressed: () {
                SimpleUserAPIAuthentication.userLogout(accessTokenOnPage);
              },
              child: Text('logout'),
            ),
            FlatButton(
              onPressed: () {
                SimpleUserAPIAuthentication.showSimpleMessage(
                    'Fetching user data...',
                    'Fetching the user data one moment please :)',
                    'info');
                SimpleUserAPIAuthentication.getUserData(
                    accessTokenOnPage, true);
              },
              child: Text('refresh data'),
            )
          ],
        ),
      ),
    );
  }
}
