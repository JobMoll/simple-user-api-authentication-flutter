import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_user_api_authentication/simple_user_api_authentication_class.dart';

class InformationPage extends StatefulWidget {
  InformationPage({Key key}) : super(key: key);
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  void _onItemTapped(int index) {
    if (index == 0) {
      Get.toNamed('/informationPage');
    } else if (index == 1) {
      Get.toNamed('/settingsPage');
    }
  }

  @override
  void initState() {
    super.initState();
    SimpleUserAPIAuthentication.getUserData(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Container(),
          title: Text(
            'Information',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.black,
                ),
                onPressed: () {
                  SimpleUserAPIAuthentication.showSimpleMessage(
                      'Fetching user data...',
                      'Fetching the user data one moment please :)',
                      'info',
                      100);

                  SimpleUserAPIAuthentication.getUserData();
                })
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 0, left: 12, right: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[],
            ),
          ),
        ),
      ),
    );
  }
}
