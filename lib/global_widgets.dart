import 'package:flutter/material.dart';

Color mainColor = Colors.white; // for the background etc
Color accentColor = Colors.black; // for the buttons, textfields etc
Color accentOppositeColor = Colors.white; // used for the icons, cursorcolor etc

TextStyle bodyText = TextStyle(fontSize: 17, color: Colors.black);
TextStyle accentElements = TextStyle(fontSize: 17, color: accentOppositeColor);

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
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: controller,
        focusNode: controllerNode,
        keyboardType: textInputType,
        autofillHints: autofillHints,
        style: accentElements,
        autocorrect: autoCorrect ?? false,
        obscureText: obscureText ?? false,
        cursorColor: accentOppositeColor,
        onEditingComplete: () => functionOnEditingComplete,
        onChanged: functionOnChange,
        decoration: InputDecoration(
          hintStyle: accentElements.copyWith(
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
