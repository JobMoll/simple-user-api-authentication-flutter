import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_user_api_authentication/information_page.dart';
import 'package:simple_user_api_authentication/loggedin_or_not.dart';
import 'package:simple_user_api_authentication/login_page.dart';

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
        return MaterialPageRoute(
          builder: (_) => LoggedinOrNotPage(),
        );
        break;

      case '/informationPage':
        return MaterialPageRoute(
          builder: (_) => InformationPage(),
        );

        break;
      case '/loginPage':
        return MaterialPageRoute(
          builder: (_) => LoginPage(),
        );

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
