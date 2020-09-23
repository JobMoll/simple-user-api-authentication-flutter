import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_user_api_authentication/loggedin_pages/information_page.dart';
import 'package:simple_user_api_authentication/loggedin_or_not.dart';
import 'package:simple_user_api_authentication/login_page.dart';
import 'forgot_password.dart';
import 'loggedin_pages/profile_page.dart';

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
          duration: 200,
        );
        break;

      case '/informationPage':
        return SuaaFadeRoute(
          page: InformationPage(),
          duration: 0,
        );
        break;

      case '/loginPage':
        return SuaaFadeRoute(
          page: LoginPage(),
          duration: 200,
        );
        break;

      case '/settingsPage':
        return SuaaFadeRoute(
          page: SettingsPage(),
          duration: 200,
        );
        break;

      case '/forgotPasswordPage':
        return SuaaFadeRoute(
          page: ForgotPasswordPage(),
          duration: 200,
        );
        break;

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
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
