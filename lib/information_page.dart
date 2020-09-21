import 'package:flutter/material.dart';
import 'package:simple_user_api_authentication/simple_user_api_authentication_class.dart';

class InformationPage extends StatefulWidget {
  InformationPage({Key key}) : super(key: key);
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  @override
  void initState() {
    super.initState();
    SimpleUserAPIAuthentication.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          title: Text('Loggedin page'),
          actions: [
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  SimpleUserAPIAuthentication.userLogout();
                })
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  SimpleUserAPIAuthentication.showSimpleMessage(
                      'Fetching user data...',
                      'Fetching the user data one moment please :)',
                      'info');
                  SimpleUserAPIAuthentication.getUserData();
                },
                child: Text('refresh data'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
