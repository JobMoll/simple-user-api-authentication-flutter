import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_user_api_authentication/global/global_widgets.dart';
import 'package:simple_user_api_authentication/loggedin_pages/information_page.dart';
import 'package:simple_user_api_authentication/non-loggedin_pages/loggedin_or_not.dart';
import 'package:simple_user_api_authentication/non-loggedin_pages/login_page.dart';
import 'package:simple_user_api_authentication/non-loggedin_pages/register_account_page.dart';
import 'non-loggedin_pages/forgot_password.dart';
import 'loggedin_pages/settings_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoggedinOrNotPage(),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return SuaaFadeRoute(
          page: LoggedinOrNotPage(),
          duration: 170,
        );
        break;

      case '/informationPage':
        return SuaaFadeRoute(
          page: InformationPage(),
          duration: 170,
        );
        break;

      case '/loginPage':
        return SuaaFadeRoute(
          page: LoginPage(),
          duration: 170,
        );
        break;

      case '/settingsPage':
        return SuaaFadeRoute(
          page: SettingsPage(),
          duration: 170,
        );
        break;

      case '/forgotPasswordPage':
        return MaterialPageRoute(builder: (context) => ForgotPasswordPage());
        break;

      case '/registerAccountPage':
        return MaterialPageRoute(builder: (context) => RegisterAccountPage());
        break;

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          title: Text(
            'Error',
            style: smallHeadingTextStyle.copyWith(color: accentOppositeColor),
          ),
        ),
        body: Center(
          child: Text('Error with page route'),
        ),
      );
    });
  }
}

class SuaaFadeRoute extends PageRouteBuilder {
  final Widget page;
  final int duration;

  SuaaFadeRoute({this.page, this.duration})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionDuration: Duration(milliseconds: duration),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
