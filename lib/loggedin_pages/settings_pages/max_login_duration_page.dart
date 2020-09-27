import 'package:flutter/material.dart';
import 'package:simple_user_api_authentication/global_widgets.dart';
import 'package:simple_user_api_authentication/simple_user_api_authentication_class.dart';

class ManageUserMaxLoginDurationPage extends StatefulWidget {
  ManageUserMaxLoginDurationPage({Key key}) : super(key: key);
  @override
  _ManageUserMaxLoginDurationPageState createState() =>
      _ManageUserMaxLoginDurationPageState();
}

class _ManageUserMaxLoginDurationPageState
    extends State<ManageUserMaxLoginDurationPage> {
  TextEditingController timeInputIntTextfield = TextEditingController();
  FocusNode timeInputIntTextfieldNode = FocusNode();

  String currentTimeInputText = 'Days';
  List<String> currentTimeInputList = [
    'Minutes',
    'Hours',
    'Days',
    'Weeks',
    'Months'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: accentOppositeColor),
          backgroundColor: accentColor,
          title: Text(
            'Max login duration',
            style: smallHeadingTextStyle.copyWith(color: accentOppositeColor),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 0, left: 12, right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Logout after how much time?',
                                style: smallHeadingTextStyle,
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                'Below you can fill in after how much time your account will be automatically logged out. The shorter the better.',
                                style: bodyTextStyle,
                              ),
                            ],
                          ),
                        ),
                        SuaaGlobalTextfield(
                          controller: timeInputIntTextfield,
                          controllerNode: timeInputIntTextfieldNode,
                          hintText: '7',
                          icon: Icons.lock_clock,
                          textInputType: TextInputType.number,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 12),
                          child: DropdownButtonHideUnderline(
                            child: Container(
                              decoration: BoxDecoration(
                                color: accentColor,
                                borderRadius: widgetsBorderRadius,
                              ),
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  dropdownColor: accentColor,
                                  focusColor: accentColor,
                                  value: currentTimeInputText,
                                  style: accentElementsTextStyle,
                                  items:
                                      currentTimeInputList.map((dynamic value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (newCurrentTimeInputText) {
                                    setState(() {
                                      currentTimeInputText =
                                          newCurrentTimeInputText;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        SuaaGlobalButton(
                          text: 'Change max login duration',
                          functionOnTap: () {
                            if (timeInputIntTextfield.text.isNotEmpty &&
                                currentTimeInputText.isNotEmpty) {
                              SimpleUserAPIAuthentication.showSimpleMessage(
                                  'Changing max login duration',
                                  'One moment while we your max login duration...',
                                  'info',
                                  100);

                              String fullTimeInputText = '+' +
                                  timeInputIntTextfield.text +
                                  ' ' +
                                  currentTimeInputText.toLowerCase();

                              SimpleUserAPIAuthentication
                                  .maxLoginDurationChange(fullTimeInputText);
                            } else {
                              SimpleUserAPIAuthentication.showSimpleMessage(
                                  'The passwords are not the same',
                                  'The passwords you filled in are not the same...',
                                  'error',
                                  3);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
