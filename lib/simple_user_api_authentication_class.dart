import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String baseDomainURL = 'https://usercookieauthenticationapi.mollupbuilding.nl/';
String accessTokenOnPage = '';

Map<String, String> httpHeaders = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
};

// post request
class HttpRequestAPIData {
  static Future httpPOSTRequestAPIData({
    @required String apiEndpointURL,
    @required String jsonData,
  }) async {
    return http.post(baseDomainURL + apiEndpointURL,
        headers: httpHeaders, body: jsonData);
  }

  static Future httpGETRequestAPIData({
    @required String apiEndpointURL,
  }) async {
    return http.get(baseDomainURL + apiEndpointURL, headers: httpHeaders);
  }
}

class SimpleUserAPIAuthentication {
  static requestRefreshToken(String username, String password) {
    Map loginData = {'username': username, 'password': password};

    HttpRequestAPIData.httpPOSTRequestAPIData(
            apiEndpointURL:
                'wp-json/simple-api-authentication/generate-refresh-token',
            jsonData: jsonEncode(loginData))
        .then((response) async {
      var refreshDecodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // print(refreshDecodedResponse['status']);
        // print(refreshDecodedResponse['refresh_token']);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('simple_user_api_authentication_refresh_token',
            refreshDecodedResponse['refresh_token']);

        SimpleUserAPIAuthentication.requestAccessTokenAndRunFunction(
            'goToInformationPage');
      } else {
        // print(decodedResponse['status']);
        // print(decodedResponse['message']);
        showSimpleMessage(
            'Login problem...', refreshDecodedResponse['message'], 'error');
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

  static getUserData(accessToken, bool refreshing) {
    HttpRequestAPIData.httpGETRequestAPIData(
      apiEndpointURL:
          'wp-json/simple-api-authentication/get-user-data?access_token=' +
              accessToken,
    ).then((response) async {
      var userDataDecodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // print(refreshDecodedResponse['status']);
        // print(refreshDecodedResponse['refresh_token']);

        if (userDataDecodedResponse['access_token_is_valid'] == true) {
          Map<String, dynamic> userDataJsonString =
              userDataDecodedResponse['user_data'];
          print(userDataJsonString);
          if (refreshing == true) {
            SimpleUserAPIAuthentication.showSimpleMessage('User data loaded!',
                'Here you have the newest user data :)', 'success');
          }
        } else {
          requestAccessTokenAndRunFunction('getUserData');
        }
      } else {
        // print(decodedResponse['status']);
        // print(decodedResponse['message']);

        print(response.body);
        requestAccessTokenAndRunFunction('getUserData');
      }
    });
  }

  static userLogout(accessToken) {
    Map refreshTokenData = {'access_token': accessToken};
    HttpRequestAPIData.httpPOSTRequestAPIData(
            apiEndpointURL:
                'wp-json/simple-api-authentication/delete-user-tokens',
            jsonData: jsonEncode(refreshTokenData))
        .then((response) async {
      var userLogoutDecodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // print(userLogoutDecodedResponse['status']);
        // print(userLogoutDecodedResponse['access_token']);
        print(userLogoutDecodedResponse);

        if (userLogoutDecodedResponse['access_token_is_valid'] == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove('simple_user_api_authentication_refresh_token');

          Get.toNamed("/loginPage");
        } else {
          requestAccessTokenAndRunFunction('userLogout');
        }
      } else {
        // print(decodedResponse['status']);
        // print(decodedResponse['message']);
        requestAccessTokenAndRunFunction('userLogout');
        print(userLogoutDecodedResponse['message']);
      }
    });
  }

  static requestAccessTokenAndRunFunction(functionName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String refreshToken =
        prefs.getString('simple_user_api_authentication_refresh_token');

    Map refreshTokenData = {'refresh_token': refreshToken};
    HttpRequestAPIData.httpPOSTRequestAPIData(
            apiEndpointURL:
                'wp-json/simple-api-authentication/generate-access-token',
            jsonData: jsonEncode(refreshTokenData))
        .then((response) {
      var accessDecodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // print(accessDecodedResponse['status']);
        // print(accessDecodedResponse['access_token']);

        print('Token: ' + accessTokenOnPage);

        if (accessDecodedResponse['access_token'] != 'failed') {
          accessTokenOnPage = accessDecodedResponse['access_token'];

          if (functionName == 'getUserData') {
            getUserData(accessTokenOnPage, false);
          } else if (functionName == 'userLogout') {
            userLogout(accessTokenOnPage);
          } else if (functionName == 'goToInformationPage') {
            Get.toNamed("/informationPage", arguments: accessTokenOnPage);
          } else {
            return;
          }
        } else {
          // print(decodedResponse['status']);
          // print(decodedResponse['message']);

          return accessDecodedResponse['message'];
        }
      } else {
        Get.toNamed("/loginPage");
      }
    });
  }

  static checkForValidRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String refreshToken =
        prefs.getString('simple_user_api_authentication_refresh_token');

    print(refreshToken);

    if (refreshToken != '' && refreshToken != null) {
      Map refreshTokenData = {'refresh_token': refreshToken};
      HttpRequestAPIData.httpPOSTRequestAPIData(
              apiEndpointURL:
                  'wp-json/simple-api-authentication/generate-access-token',
              jsonData: jsonEncode(refreshTokenData))
          .then((response) {
        var accessDecodedResponse = jsonDecode(response.body);
        if (response.statusCode == 200) {
          // print(accessDecodedResponse['status']);
          // print(accessDecodedResponse['access_token']);
          Get.toNamed("/informationPage",
              arguments: accessDecodedResponse['access_token']);
        } else {
          // print(decodedResponse['status']);
          // print(decodedResponse['message']);

          print(accessDecodedResponse['message']);
          Get.toNamed("/loginPage");
        }
      });
    } else {
      Get.toNamed("/loginPage");
    }
  }
}
