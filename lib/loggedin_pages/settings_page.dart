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
  bool useBiometric = false;
  int appPasscodeLength = 5;

  TextEditingController appPasscode = TextEditingController();
  TextEditingController appPasscodeCheck = TextEditingController();

  FocusNode appPasscodeNode = FocusNode();
  FocusNode appPasscodeCheckNode = FocusNode();

  List<int> totalPasscodeInputList = [];
  List<dynamic> totalPasscodeInputListFirst = [];

  bool passcodeIsEnabled = false;
  getPasscodeToUserAcccountOnPage() async {
    SUAAPasscode.getPasscodeToUserAcccount().then((passcode) {
      print('Passcode: ' + passcode.toString());

      if (passcode != '' && passcode != null) {
        setState(() {
          passcodeIsEnabled = true;
        });
      }
    });
  }

  Future setPasswordPopup({
    IconData icon,
    BuildContext context,
    String title,
    String description,
    bool isDeleteButton,
  }) {
    return showGeneralDialog(
      barrierLabel: title,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  bottom: false,
                  child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 12,
                          right: 12,
                          top: MediaQuery.of(context).size.height * 0.2),
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

                          SuaaPasscodeCount(
                            totalPasscodeVar: totalPasscodeInputList,
                            appPasscodeLength: appPasscodeLength,
                          ),

                          SuaaPasscodeInput(
                            totalPasscodeVar: totalPasscodeInputList,
                            functionOnItemTap: () {
                              if (totalPasscodeInputList.length ==
                                  appPasscodeLength) {
                                if (totalPasscodeInputListFirst.isEmpty) {
                                  setState(() {
                                    totalPasscodeInputListFirst
                                        .addAll(totalPasscodeInputList);
                                    totalPasscodeInputList.clear();
                                  });
                                } else {
                                  String totalPasscode =
                                      totalPasscodeInputList.join('');
                                  String totalPasscodeFirst =
                                      totalPasscodeInputListFirst.join('');

                                  if (totalPasscode == totalPasscodeFirst) {
                                    // passcodes are the same!! succes
                                    Get.close(1);

                                    SUAAPasscode.changePasscodeToUserAcccount(
                                        totalPasscodeFirst);

                                    setState(() {
                                      //TODO call this on the main page not in the plugin state
                                      passcodeIsEnabled = true;
                                      totalPasscodeInputListFirst.clear();
                                      totalPasscodeInputList.clear();
                                    });
                                  } else {
                                    // passcodes do not match
                                    setState(() {
                                      totalPasscodeInputListFirst.clear();
                                      totalPasscodeInputList.clear();
                                    });

                                    SUAABasics.showSimpleMessage(
                                        "Passcodes do not match",
                                        "The passcodes don't match, try again!",
                                        'error',
                                        3);
                                  }
                                }
                              } else {
                                setState(() {});
                              }
                            },
                          ),

                          Container(
                            margin: EdgeInsets.only(
                              top: 24,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  totalPasscodeInputListFirst.clear();
                                  totalPasscodeInputList.clear();
                                });

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
              ),
            );
          },
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
    getPasscodeToUserAcccountOnPage();
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
                            'App passcode',
                            style: bodyTextStyle,
                          ),
                          Spacer(),
                          SuaaGlobalSwitch(
                            varName: passcodeIsEnabled,
                            varFunction: (newValue) {
                              if (newValue == false) {
                                SUAAPasscode.changePasscodeToUserAcccount(
                                    false);

                                setState(() {
                                  useBiometric = newValue;
                                  passcodeIsEnabled = newValue;
                                });
                              } else {
                                setPasswordPopup(
                                  icon: Icons.lock,
                                  context: context,
                                  title: 'Lock automatically',
                                  description:
                                      'When you close and reopen the app you have to fill in a password to get access to the data.',
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
                            color: passcodeIsEnabled
                                ? Colors.black
                                : Colors.black54,
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Text(
                            'Use biometric',
                            style: passcodeIsEnabled
                                ? bodyTextStyle
                                : bodyTextStyle.copyWith(color: Colors.black54),
                          ),
                          Spacer(),
                          SuaaGlobalSwitch(
                            varName: useBiometric,
                            varFunction: (newValue) async {
                              if (newValue == true) {
                                setState(() {
                                  useBiometric = newValue;
                                });
                              } else {
                                setState(() {
                                  useBiometric = newValue;
                                });
                              }
                            },
                            disabledSwitch: passcodeIsEnabled,
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
                      SUAABasics.showSimpleMessage('Loggin you out',
                          'One moment while we log you out...', 'info', 100);
                      SUAAAuth.userLogout(true);
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

class SuaaPasscodeCount extends StatelessWidget {
  const SuaaPasscodeCount({
    Key key,
    @required this.totalPasscodeVar,
    @required this.appPasscodeLength,
  }) : super(key: key);

  final List<int> totalPasscodeVar;
  final int appPasscodeLength;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 30,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: appPasscodeLength,
                itemBuilder: (BuildContext context, int index) {
                  return Icon(
                    Icons.circle,
                    color: totalPasscodeVar.length >= index + 1
                        ? accentColor
                        : accentColor.withOpacity(0.3),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class SuaaPasscodeInput extends StatelessWidget {
  const SuaaPasscodeInput({
    Key key,
    @required this.totalPasscodeVar,
    @required this.functionOnItemTap,
  }) : super(key: key);

  final List totalPasscodeVar;
  final Function functionOnItemTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              SuaaPasscodeItem(
                number: 1,
                totalPasscodeVar: totalPasscodeVar,
                functionOnItemTap: functionOnItemTap,
              ),
              SuaaPasscodeItem(
                number: 2,
                totalPasscodeVar: totalPasscodeVar,
                functionOnItemTap: functionOnItemTap,
              ),
              SuaaPasscodeItem(
                number: 3,
                totalPasscodeVar: totalPasscodeVar,
                functionOnItemTap: functionOnItemTap,
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SuaaPasscodeItem(
              number: 4,
              totalPasscodeVar: totalPasscodeVar,
              functionOnItemTap: functionOnItemTap,
            ),
            SuaaPasscodeItem(
              number: 5,
              totalPasscodeVar: totalPasscodeVar,
              functionOnItemTap: functionOnItemTap,
            ),
            SuaaPasscodeItem(
              number: 6,
              totalPasscodeVar: totalPasscodeVar,
              functionOnItemTap: functionOnItemTap,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SuaaPasscodeItem(
              number: 7,
              totalPasscodeVar: totalPasscodeVar,
              functionOnItemTap: functionOnItemTap,
            ),
            SuaaPasscodeItem(
              number: 8,
              totalPasscodeVar: totalPasscodeVar,
              functionOnItemTap: functionOnItemTap,
            ),
            SuaaPasscodeItem(
              number: 9,
              totalPasscodeVar: totalPasscodeVar,
              functionOnItemTap: functionOnItemTap,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: Container()),
            SuaaPasscodeItem(
              number: 0,
              totalPasscodeVar: totalPasscodeVar,
              functionOnItemTap: functionOnItemTap,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (totalPasscodeVar.length > 0) {
                    totalPasscodeVar.removeLast();
                    functionOnItemTap();
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      border: Border.all(color: accentColor.withOpacity(0.2))),
                  child: Icon(
                    Icons.delete,
                    size: 21,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class SuaaPasscodeItem extends StatelessWidget {
  const SuaaPasscodeItem({
    Key key,
    @required this.number,
    @required this.totalPasscodeVar,
    @required this.functionOnItemTap,
  }) : super(key: key);

  final int number;
  final List totalPasscodeVar;
  final Function functionOnItemTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          totalPasscodeVar.add(number);
          functionOnItemTap();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
              border: Border.all(color: accentColor.withOpacity(0.2))),
          child: Text(
            number.toString(),
            style: smallHeadingTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
