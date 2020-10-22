import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_user_api_authentication/global/global_widgets.dart';
import 'package:simple_user_api_authentication/loggedin_pages/settings_pages/change_user_details.dart';
import 'package:simple_user_api_authentication/loggedin_pages/settings_pages/max_login_duration_page.dart';
import 'package:simple_user_api_authentication/global/simple_user_api_authentication_class.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: mainColor,
        bottomNavigationBar: SuaaGlobalNavigationBar(
          notActiveTab1: false,
          notActiveTab2: true,
        ),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 0, left: 12, right: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 65, top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(color: Colors.black, fontSize: 30),
                      ),
                      Text(
                        'Email',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                // my account
                Container(
                  margin: EdgeInsets.only(bottom: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'My account',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: GestureDetector(
                          onTap: () async {
                            Get.to(ChangeUserDetailsPage());
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Text(
                                'Personal details',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // safety
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        'Safety',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    // manage login duration
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        onTap: () async {
                          Get.to(ManageUserMaxLoginDurationPage());
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Text(
                              'Manage login duration',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // app passcode
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        onTap: () async {
                          Get.to(ManageUserMaxLoginDurationPage());
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.code,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Text(
                              'App passcode',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // logout
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Divider(
                    color: Colors.black38,
                  ),
                ),
                Container(
                  child: GestureDetector(
                    onTap: () async {
                      SimpleUserAPIAuthentication.showSimpleMessage(
                          'Loggin you out',
                          'One moment while we log you out...',
                          'info',
                          100);
                      SimpleUserAPIAuthentication.userLogout(true);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Text(
                          'Uitloggen',
                          style: TextStyle(color: Colors.red, fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
