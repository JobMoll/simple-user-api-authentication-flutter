import 'dart:convert';
import 'package:dio/dio.dart' as dioCalls;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    as secureStorage;
import 'package:get/get.dart';

final dio = dioCalls.Dio(
  dioCalls.BaseOptions(
    baseUrl: 'https://usercookieauthenticationapi.mollupbuilding.nl',
    followRedirects: false,
    validateStatus: (status) {
      return status < 500;
    },
  ),
);

final storage = new secureStorage.FlutterSecureStorage();

class SimpleUserAPIAuthentication {
  static requestRefreshToken(String usernameOrEmail, String password) {
    Map<String, String> loginData = {
      'username_or_email': usernameOrEmail,
      'password': password
    };

    dio
        .post('/wp-json/simple-user-api-authentication/generate-refresh-token',
            data: loginData)
        .then((response) async {
      var responseData = response.data;
      if (response.statusCode == 200) {
        await storage.write(
            key: 'simple_user_api_authentication_refresh_token',
            value: responseData['refresh_token']);

        await storage.write(
            key: 'simple_user_api_authentication_user_id',
            value: responseData['user_id'].toString());

        SimpleUserAPIAuthentication.showSimpleMessage('Your login is correct!',
            'You are successfully loggedin', 'success', 3);

        Get.offNamed('/informationPage');
      } else {
        showSimpleMessage(
            'Login problem...', responseData['message'], 'error', 3);
      }
    });
  }

  static requestAccessToken(VoidCallback name) async {
    String refreshToken =
        await storage.read(key: 'simple_user_api_authentication_refresh_token');

    Map<String, String> refreshTokenData = {'refresh_token': refreshToken};

    dio
        .post('/wp-json/simple-user-api-authentication/generate-access-token',
            data: refreshTokenData)
        .then((response) async {
      var responseData = response.data;
      if (response.statusCode == 200) {
        if (responseData['access_token'] != 'failed') {
          await storage.write(
              key: 'simple_user_api_authentication_access_token',
              value: responseData['access_token']);

          if (name == getUserData) {
            getUserData(true);
          } else {
            name();
          }
        } else {
          return responseData['message'];
        }
      } else {
        userLogout();
      }
    });
  }

  static checkForValidRefreshToken() async {
    String refreshToken =
        await storage.read(key: 'simple_user_api_authentication_refresh_token');

    if (refreshToken != '' && refreshToken != null) {
      Map<String, String> refreshTokenData = {'refresh_token': refreshToken};

      dio
          .post(
        '/wp-json/simple-user-api-authentication/generate-access-token',
        data: json.encode(refreshTokenData),
      )
          .then((response) {
        var responseData = response.data;
        if (response.statusCode == 200) {
          storage.write(
              key: 'simple_user_api_authentication_access_token',
              value: responseData['access_token']);

          Get.offNamed("/informationPage");
        } else {
          userLogout();
        }
      });
    } else {
      userLogout(true);
    }
  }

  static getUserData([bool initialLoad]) async {
    String accessToken =
        await storage.read(key: 'simple_user_api_authentication_access_token');

    Map<String, String> accessTokenData = {'access_token': accessToken};

    dio
        .post('/wp-json/simple-user-api-authentication/get-user-data',
            data: accessTokenData)
        .then((response) async {
      var responseData = response.data;

      if (response.statusCode == 200) {
        if (initialLoad != true) {
          SimpleUserAPIAuthentication.showSimpleMessage('User data fetched!',
              'Here is the newest user data :)', 'success', 3);
        }

        Map<String, dynamic> userDataJsonString = responseData['user_data'];
        print(userDataJsonString);
      } else {
        return requestAccessToken(getUserData);
      }
    });
  }

  static userLogout([bool initialLoad]) async {
    String userID =
        await storage.read(key: 'simple_user_api_authentication_user_id');

    if (userID != null && userID != '') {
      Map<String, String> requestData = {'user_id': userID};

      dio
          .post('/wp-json/simple-user-api-authentication/delete-user-tokens',
              data: requestData)
          .then((response) async {
        if (response.statusCode == 200) {
          await storage.delete(
              key: 'simple_user_api_authentication_refresh_token');
          await storage.delete(
              key: 'simple_user_api_authentication_access_token');
          await storage.delete(key: 'simple_user_api_authentication_user_id');

          Get.offNamed("/loginPage");

          if (initialLoad != true) {
            SimpleUserAPIAuthentication.showSimpleMessage(
                'Loggin out succesful!',
                'You are succesfully loggedout :)',
                'success',
                3);
          }
        } else {
          requestAccessToken(userLogout);
        }
      });
    } else {
      Get.offNamed("/loginPage");
    }
  }

  static forgotPassword(String usernameOrEmail) async {
    Map<String, String> requestData = {'username_or_email': usernameOrEmail};

    dio
        .post('/wp-json/simple-user-api-authentication/forgot-password',
            data: requestData)
        .then((response) async {
      var responseData = response.data;
      if (response.statusCode == 200) {
        SimpleUserAPIAuthentication.showSimpleMessage(responseData['title'],
            responseData['message'], responseData['status'], 3);
      }
    });
  }

  static registerNewUser(String username, String email) async {
    Map<String, String> requestData = {'username': username, 'email': email};

    dio
        .post('/wp-json/simple-user-api-authentication/register-a-new-user',
            data: requestData)
        .then((response) async {
      var responseData = response.data;
      if (response.statusCode == 200) {
        SimpleUserAPIAuthentication.showSimpleMessage(responseData['title'],
            responseData['message'], responseData['status'], 3);
      }
    });
  }

  static showSimpleMessage(
      String title, String message, String messageStatus, int durationInSec) {
    IconData icon = Icons.info_outline;
    Color color = Colors.blue;
    if (messageStatus == 'info') {
      icon = Icons.info_outline;
      color = Colors.blue;
    } else if (messageStatus == 'error') {
      icon = Icons.error_outline;
      color = Colors.red;
    } else if (messageStatus == 'success') {
      icon = Icons.check_circle_outline;
      color = Colors.green;
    }

    if (Get.isSnackbarOpen) {
      Get.close(1);
    }

    Get.snackbar(
      title,
      message,
      colorText: Colors.white,
      icon: Icon(
        icon,
        color: color,
        size: 30,
      ),
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(10),
      borderRadius: 0,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      shouldIconPulse: true,
      barBlur: 100,
      isDismissible: true,
      duration: Duration(seconds: durationInSec),
    );
  }
}
