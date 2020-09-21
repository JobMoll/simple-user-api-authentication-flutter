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
                  SimpleUserAPIAuthentication.showSimpleMessage(
                      'Loggin you out',
                      'One moment while we log you out...',
                      'info',
                      100);
                  SimpleUserAPIAuthentication.userLogout();
                })
          ],
        ),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 0, left: 12, right: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    SimpleUserAPIAuthentication.showSimpleMessage(
                        'Fetching user data...',
                        'Fetching the user data one moment please :)',
                        'info',
                        100);
                    SimpleUserAPIAuthentication.getUserData();
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
                        'Refresh data',
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
