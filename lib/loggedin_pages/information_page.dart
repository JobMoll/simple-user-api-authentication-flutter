import 'package:flutter/material.dart';
import 'package:simple_user_api_authentication/global/global_widgets.dart';
import 'package:simple_user_api_authentication/global/simple_user_api_authentication_class.dart';

class InformationPage extends StatefulWidget {
  InformationPage({Key key}) : super(key: key);
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  @override
  void initState() {
    super.initState();

    SUAAUserDetails.getUserData(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: accentOppositeColor),
          backgroundColor: accentColor,
          leading: Container(),
          title: Text(
            'Information',
            style: smallHeadingTextStyle.copyWith(color: accentOppositeColor),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.refresh, color: accentOppositeColor),
                onPressed: () {
                  SUAABasics.showSimpleMessage(
                      'Fetching user data...',
                      'Fetching the user data one moment please :)',
                      'info',
                      100);

                  SUAAUserDetails.getUserData();
                })
          ],
        ),
        bottomNavigationBar: SuaaGlobalNavigationBar(
          notActiveTab1: true,
          notActiveTab2: false,
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
