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
// 1. get the refresh token with the login details
// 2. get the access token with the refresh token
// 3. get user data with the access token

  static requestRefreshToken(String username, String password) {
    Map<String, String> loginData = {
      'username': username,
      'password': password
    };

    dio
        .post('/wp-json/simple-api-authentication/generate-refresh-token',
            data: loginData)
        .then((response) async {
      var responseData = response.data;
      if (response.statusCode == 200) {
        await storage.write(
            key: 'simple_user_api_authentication_refresh_token',
            value: responseData['refresh_token']);

        SimpleUserAPIAuthentication.requestAccessToken(getUserData);
      } else {
        showSimpleMessage('Login problem...', responseData['message'], 'error');
      }
    });
  }

  static requestAccessToken(VoidCallback name) async {
    String refreshToken =
        await storage.read(key: 'simple_user_api_authentication_refresh_token');

    Map<String, String> refreshTokenData = {'refresh_token': refreshToken};

    dio
        .post('/wp-json/simple-api-authentication/generate-access-token',
            data: refreshTokenData)
        .then((response) async {
      var responseData = response.data;
      if (response.statusCode == 200) {
        if (responseData['access_token'] != 'failed') {
          await storage.write(
              key: 'simple_user_api_authentication_access_token',
              value: responseData['access_token']);

          name();
        } else {
          return responseData['message'];
        }
      } else {
        Get.offNamed("/loginPage");
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
        '/wp-json/simple-api-authentication/generate-access-token',
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
          Get.offNamed("/loginPage");
        }
      });
    } else {
      Get.offNamed("/loginPage");
    }
  }

  static getUserData() async {
    String accessToken =
        await storage.read(key: 'simple_user_api_authentication_access_token');

    Map<String, String> accessTokenData = {'access_token': accessToken};

    dio
        .post('/wp-json/simple-api-authentication/get-user-data',
            data: accessTokenData)
        .then((response) async {
      var responseData = response.data;

      print(response.statusCode);

      if (response.statusCode == 200) {
        if (responseData['access_token_is_valid'] == true) {
          Map<String, dynamic> userDataJsonString = responseData['user_data'];
          print(userDataJsonString);
        } else {
          return requestAccessToken(getUserData);
        }
      } else if (response.statusCode == 401) {
        return requestAccessToken(getUserData);
      }
    });
  }

  static userLogout() async {
    String accessToken = await storage.read(
      key: 'simple_user_api_authentication_access_token',
    );

    Map<String, String> accessTokenData = {'access_token': accessToken};
    dio
        .post('/wp-json/simple-api-authentication/delete-user-tokens',
            data: accessTokenData)
        .then((response) async {
      var responseData = jsonDecode(response.data);
      if (response.statusCode == 200) {
        if (responseData['access_token_is_valid'] == true) {
          await storage.delete(
              key: 'simple_user_api_authentication_refresh_token');
          await storage.delete(
              key: 'simple_user_api_authentication_access_token');
          Get.offNamed("/loginPage");
        } else {
          requestAccessToken(userLogout);
        }
      } else {
        requestAccessToken(userLogout);
      }
    });
  }

  static showSimpleMessage(String title, String message, String messageSort) {
    IconData icon = Icons.info_outline;
    Color color = Colors.blue;
    if (messageSort == 'info') {
      icon = Icons.info_outline;
      color = Colors.blue;
    } else if (messageSort == 'error') {
      icon = Icons.error_outline;
      color = Colors.red;
    } else if (messageSort == 'success') {
      icon = Icons.check_circle_outline;
      color = Colors.green;
    }

    Get.snackbar(
      title, // title
      message,
      colorText: Colors.white, // message
      icon: Icon(
        icon,
        color: color,
      ),
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(10),
      borderRadius: 0,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      shouldIconPulse: false,
      barBlur: 100,
      isDismissible: true,
      duration: Duration(seconds: 3),
    );
  }
}
