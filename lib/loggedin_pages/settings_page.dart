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
  bool lockAutomaticallySwitch = false;
  bool useBiometric = false;
  int appPasscodeLength = 5;

  TextEditingController appPasscode = TextEditingController();
  TextEditingController appPasscodeCheck = TextEditingController();

  FocusNode appPasscodeNode = FocusNode();
  FocusNode appPasscodeCheckNode = FocusNode();

  Future setPasswordPopup(
      {IconData icon,
      BuildContext context,
      String title,
      String description,
      Function confirmFunction,
      bool isDeleteButton}) {
    return showGeneralDialog(
      barrierLabel: title,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (_, __, ___) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                height: 600,
                margin: EdgeInsets.symmetric(horizontal: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: widgetsBorderRadius,
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    Icon(
                      icon,
                      size: 40,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 10,
                      ),
                      child: Text(
                        title,
                        style: smallHeadingTextStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 6,
                      ),
                      child: Text(
                        description,
                        style: bodyTextStyle,
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // passcode input here
                    SuaaGlobalTextfield(
                      controller: appPasscode,
                      controllerNode: appPasscodeNode,
                      hintText:
                          appPasscodeLength.toString() + ' Digit passcode',
                      icon: Icons.lock_open,
                      obscureText: true,
                      maxCharacterInput: appPasscodeLength,
                      textInputType: TextInputType.number,
                      functionOnEditingComplete: () {
                        FocusScope.of(context)
                            .requestFocus(appPasscodeCheckNode);
                      },
                    ),
                    SuaaGlobalTextfield(
                      controller: appPasscodeCheck,
                      controllerNode: appPasscodeCheckNode,
                      hintText: 'Confirm ' +
                          appPasscodeLength.toString() +
                          ' digit passcode',
                      icon: Icons.lock_open,
                      obscureText: true,
                      maxCharacterInput: appPasscodeLength,
                      textInputType: TextInputType.number,
                    ),

                    SuaaGlobalButton(
                      text: 'Confirm',
                      functionOnTap: confirmFunction,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 12,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Get.close(1);
                        },
                        child: Text(
                          'Cancel',
                          style: bodyTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

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
                          style: bodyTextStyle.copyWith(fontSize: 18),
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
                                style: bodyTextStyle,
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
                        style: bodyTextStyle.copyWith(fontSize: 18),
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
                              style: bodyTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // app passcode

                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Text(
                            'Lock automatically',
                            style: bodyTextStyle,
                          ),
                          Spacer(),
                          SuaaGlobalSwitch(
                            varName: lockAutomaticallySwitch,
                            varFunction: (newValue) {
                              print(newValue);
                              if (newValue == false) {
                                //  removePasswordPopup();
                                setState(() {
                                  useBiometric = newValue;
                                  lockAutomaticallySwitch = newValue;
                                });
                              }

                              if (newValue == true) {
                                setPasswordPopup(
                                  icon: Icons.lock,
                                  context: context,
                                  title: 'Lock automatically',
                                  description:
                                      'When you close and reopen the app you have to fill in a password to get access to the data.',
                                  confirmFunction: () {
                                    if (appPasscode.text.isNotEmpty &&
                                        appPasscodeCheck.text.isNotEmpty) {
                                      if (appPasscode.text.length ==
                                              appPasscodeLength &&
                                          appPasscodeCheck.text.length ==
                                              appPasscodeLength) {
                                        if (appPasscode.text ==
                                            appPasscodeCheck.text) {
                                          setState(() {
                                            appPasscode.text = '';
                                            appPasscodeCheck.text = '';
                                            Get.close(1);
                                            lockAutomaticallySwitch = newValue;
                                          });
                                        } else {
                                          SimpleUserAPIAuthentication
                                              .showSimpleMessage(
                                                  "App passcode do not match",
                                                  'The app passcodes you filled in have to be the same...',
                                                  'error',
                                                  3);
                                        }
                                      } else {
                                        SimpleUserAPIAuthentication
                                            .showSimpleMessage(
                                                "App passcode wrong length",
                                                'App passcode should be ' +
                                                    appPasscodeLength
                                                        .toString() +
                                                    ' numbers long...',
                                                'error',
                                                3);
                                      }
                                    } else {
                                      SimpleUserAPIAuthentication.showSimpleMessage(
                                          "App passcode field(s) empty",
                                          'You forgot to fill in one of the app passcode fields...',
                                          'error',
                                          3);
                                    }
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    // use biometric
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.fingerprint,
                            color: lockAutomaticallySwitch
                                ? Colors.black
                                : Colors.black54,
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Text(
                            'Use biometric',
                            style: lockAutomaticallySwitch
                                ? bodyTextStyle
                                : bodyTextStyle.copyWith(color: Colors.black54),
                          ),
                          Spacer(),
                          SuaaGlobalSwitch(
                            varName: useBiometric,
                            varFunction: (newValue) {
                              setState(() {
                                useBiometric = newValue;
                              });
                            },
                            disabledSwitch: lockAutomaticallySwitch,
                          ),
                        ],
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
