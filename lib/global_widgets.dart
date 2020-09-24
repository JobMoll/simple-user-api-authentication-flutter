import 'package:flutter/material.dart';
import 'package:get/get.dart';

Color mainColor = Colors.white; // for the background etc
Color accentColor = Colors.black; // for the buttons, textfields etc
Color accentOppositeColor = Colors.white; // used for the icons, cursorcolor etc

BorderRadius widgetsBorderRadius = BorderRadius.circular(5);

TextStyle bodyTextStyle = TextStyle(fontSize: 17, color: Colors.black);
TextStyle smallHeadingTextStyle =
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black);
TextStyle accentElementsTextStyle =
    TextStyle(fontSize: 17, color: accentOppositeColor);

class SuaaGlobalTextfield extends StatelessWidget {
  const SuaaGlobalTextfield({
    Key key,
    @required this.controller,
    @required this.controllerNode,
    @required this.hintText,
    this.icon,
    this.textInputType,
    this.autofillHints,
    this.autoCorrect,
    this.obscureText,
    this.functionOnEditingComplete,
    this.functionOnChange,
  }) : super(key: key);

  final TextEditingController controller;
  final FocusNode controllerNode;
  final String hintText;
  final TextInputType textInputType;
  final Iterable<String> autofillHints;
  final bool autoCorrect;
  final bool obscureText;
  final IconData icon;
  final Function functionOnEditingComplete;
  final Function functionOnChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: widgetsBorderRadius,
      ),
      child: TextField(
        controller: controller,
        focusNode: controllerNode,
        keyboardType: textInputType,
        autofillHints: autofillHints,
        style: accentElementsTextStyle,
        autocorrect: autoCorrect ?? false,
        obscureText: obscureText ?? false,
        cursorColor: accentOppositeColor,
        onEditingComplete: functionOnEditingComplete,
        onChanged: functionOnChange,
        decoration: InputDecoration(
          hintStyle: accentElementsTextStyle.copyWith(
              color: accentOppositeColor.withOpacity(0.65)),
          hintText: hintText,
          suffixIcon: Icon(
            icon,
            color: accentOppositeColor,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(18),
        ),
      ),
    );
  }
}

class SuaaGlobalButton extends StatelessWidget {
  const SuaaGlobalButton(
      {Key key, @required this.text, @required this.functionOnTap})
      : super(key: key);
  final String text;
  final Function functionOnTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: functionOnTap,
      child: Container(
        margin: EdgeInsets.only(top: 12),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: widgetsBorderRadius,
        ),
        child: Text(
          text,
          style: accentElementsTextStyle,
        ),
      ),
    );
  }
}

class SuaaGlobalNavigationBar extends StatelessWidget {
  const SuaaGlobalNavigationBar({
    this.notActiveTab1,
    this.notActiveTab2,
  });

  final bool notActiveTab1;
  final bool notActiveTab2;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: mainColor,
        ),
        height: 50,
        padding: EdgeInsets.only(top: 11),
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: 69.0,
        ),
        child: Container(
          margin: EdgeInsets.only(top: 0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SuaaGlobalNavigationBarItem(
                  notActiveTab: notActiveTab1,
                  title: 'Home',
                  icon: Icons.home,
                  iconColor: accentColor,
                  itemFunction: () {
                    Get.toNamed('/informationPage');
                  },
                ),
                SuaaGlobalNavigationBarItem(
                  notActiveTab: notActiveTab2,
                  title: 'Settings',
                  icon: Icons.settings,
                  iconColor: accentColor,
                  itemFunction: () {
                    Get.toNamed('/settingsPage');
                  },
                ),
              ]),
        ),
      ),
    );
  }
}

class SuaaGlobalNavigationBarItem extends StatelessWidget {
  const SuaaGlobalNavigationBarItem({
    this.notActiveTab,
    this.title,
    this.icon,
    this.iconColor,
    this.itemFunction,
  });

  final bool notActiveTab;
  final String title;
  final IconData icon;
  final Color iconColor;
  final Function itemFunction;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: notActiveTab ?? false
          ? GestureDetector(
              onTap: itemFunction,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 18),
                height: 60,
                color: Colors.transparent,
                child: Column(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          color: accentColor, fontSize: 14, height: 1.25),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    ClipOval(
                      child: Material(
                        color: accentColor,
                        child: SizedBox(width: 4, height: 4),
                      ),
                    )
                  ],
                ),
              ),
            )
          : GestureDetector(
              onTap: itemFunction,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 18),
                height: 60,
                color: Colors.transparent,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 22.0,
                  ),
                ),
              ),
            ),
    );
  }
}
