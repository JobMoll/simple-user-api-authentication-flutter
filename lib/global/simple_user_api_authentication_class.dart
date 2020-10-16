import 'dart:convert';
import 'package:dio/dio.dart' as dioCalls;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    as secureStorage;
import 'package:get/get.dart';
import 'package:flutter/services.dart';

String baseDomainUrl = 'https://usercookieauthenticationapi.mollupbuilding.nl';

final dioSuaa = dioCalls.Dio(
  dioCalls.BaseOptions(
      baseUrl: baseDomainUrl,
      followRedirects: false,
      validateStatus: (status) {
        return status < 500;
      }),
);

final dioSuaaRefreshAccessToken = dioCalls.Dio(
  dioCalls.BaseOptions(
      baseUrl: baseDomainUrl,
      followRedirects: false,
      validateStatus: (status) {
        return status < 500;
      }),
);

final storage = new secureStorage.FlutterSecureStorage();

class SimpleUserAPIAuthentication {
  static requestRefreshToken(String usernameOrEmail, String password) {
    Map<String, String> loginData = {
      'username_or_email': usernameOrEmail,
      'password': password
    };

    dioSuaa
        .post('/wp-json/simple-user-api-authentication/generate-refresh-token',
            data: loginData)
        .then((response) async {
      var responseData = response.data;
      if (response.statusCode == 200) {
        await storage.write(
            key: 'simple_user_api_authentication_refresh_token',
            value: responseData['new_refresh_token']);

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

  static checkForValidRefreshToken() async {
    String refreshToken =
        await storage.read(key: 'simple_user_api_authentication_refresh_token');

    if (refreshToken != '' && refreshToken != null) {
      Map<String, String> refreshTokenData = {'refresh_token': refreshToken};

      dioSuaa
          .post(
        '/wp-json/simple-user-api-authentication/generate-access-token',
        data: json.encode(refreshTokenData),
      )
          .then((response) {
        var responseData = response.data;
        if (response.statusCode == 200) {
          storage.write(
              key: 'simple_user_api_authentication_access_token',
              value: responseData['new_access_token']);

          dioSuaa.interceptors.add(
            InterceptorsWrapper(
              onRequest: (RequestOptions options) {
                print('send request：${options.baseUrl}${options.path}');
              },
              onResponse: (Response response) async {
                print(response.statusCode);
                if (response.statusCode == 401) {
                  RequestOptions options = response.request;
                  // // If the token has been updated, repeat directly.
                  // if (csrfToken != options.headers["csrfToken"]) {
                  //   options.headers["csrfToken"] = csrfToken;
                  //   //repeat
                  //   return dioSuaa.request(options.path, options: options);
                  // }
                  // // update token and repeat
                  // // Lock to block the incoming request until the token updated
                  dioSuaa.lock();
                  dioSuaa.interceptors.responseLock.lock();
                  dioSuaa.interceptors.errorLock.lock();

                  String refreshToken = await storage.read(
                      key: 'simple_user_api_authentication_refresh_token');
                  Map<String, String> refreshTokenData = {
                    'refresh_token': refreshToken
                  };

                  return dioSuaaRefreshAccessToken
                      .post(
                          '/wp-json/simple-user-api-authentication/generate-access-token',
                          data: refreshTokenData)
                      .then((response) {
                    var responseData = response.data;
                    if (response.statusCode == 200 &&
                        responseData['status'] != 'error') {
                      storage.write(
                          key: 'simple_user_api_authentication_access_token',
                          value: responseData['new_access_token']);

                      options.data["access_token"] =
                          responseData['new_access_token'];
                    } else {
                      // refresh token is not valid
                      print('Refresh token is not valid');
                      SimpleUserAPIAuthentication.userLogout();
                    }
                  }).whenComplete(() {
                    dioSuaa.unlock();
                    dioSuaa.interceptors.responseLock.unlock();
                    dioSuaa.interceptors.errorLock.unlock();
                  }).then((e) {
                    //repeat
                    return dioSuaa.request(options.path, options: options);
                  });
                }
              },
              onError: (DioError error) async {
                //print(error);

                // Assume 401 stands for token expired

                return error;
              },
            ),
          );

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

    dioSuaa
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
        print(jsonEncode(userDataJsonString));
      }
    });
  }

  static changeUserData(String firstName, String lastName, String email) async {
    String accessToken =
        await storage.read(key: 'simple_user_api_authentication_access_token');

    Map<String, String> requestData = {
      'access_token': accessToken,
      'new_first_name': firstName,
      'new_last_name': lastName,
      'new_user_email': email,
    };

    dioSuaa
        .post('/wp-json/simple-user-api-authentication/change-user-data',
            data: requestData)
        .then((response) async {
      var responseData = response.data;

      if (response.statusCode == 200) {
        if (responseData['status'] == 'success') {
          SimpleUserAPIAuthentication.showSimpleMessage(responseData['title'],
              responseData['message'], responseData['status'], 3);
        }
      }
    });
  }

  static changePassword(String newPassword) async {
    String accessToken =
        await storage.read(key: 'simple_user_api_authentication_access_token');

    Map<String, String> requestData = {
      'access_token': accessToken,
      'new_password': newPassword
    };

    dioSuaa
        .post('/wp-json/simple-user-api-authentication/change-password',
            data: requestData)
        .then((response) async {
      var responseData = response.data;
      print(responseData);

      if (response.statusCode == 200) {
        SimpleUserAPIAuthentication.showSimpleMessage(responseData['title'],
            responseData['message'], responseData['status'], 3);

        if (responseData['status'] == 'success') {
          userLogout();
        }
      }
    });
  }

  static changeMaxLoginDuration(String newMaxLoginDuration) async {
    String accessToken =
        await storage.read(key: 'simple_user_api_authentication_access_token');

    Map<String, String> requestData = {
      'access_token': accessToken,
      'new_max_login_duration': newMaxLoginDuration
    };

    dioSuaa
        .post(
            '/wp-json/simple-user-api-authentication/user-change-max-login-duration',
            data: requestData)
        .then((response) async {
      var responseData = response.data;

      if (response.statusCode == 200) {
        if (responseData['status'] == 'success') {
          SimpleUserAPIAuthentication.showSimpleMessage(responseData['title'],
              responseData['message'], responseData['status'], 3);

          userLogout();
        }
      }
    });
  }

  static userLogout([bool initialLoad]) async {
    String userID =
        await storage.read(key: 'simple_user_api_authentication_user_id');

    if (userID != null && userID != '') {
      Map<String, String> requestData = {'user_id': userID};

      dioSuaa
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
                'Successfully logged out',
                'You are succesfully logged out!',
                'success',
                3);
          }
        }
      });
    } else {
      Get.offNamed("/loginPage");
    }
  }

  static forgotPassword(String usernameOrEmail) async {
    Map<String, String> requestData = {'username_or_email': usernameOrEmail};

    dioSuaa
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

    dioSuaa
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

  static Future<MaxLoginDurationClass> getMaxLoginDuration() async {
    String accessToken =
        await storage.read(key: 'simple_user_api_authentication_access_token');

    Map<String, String> requestData = {
      'access_token': accessToken,
    };

    var response = await dioSuaa.post(
        '/wp-json/simple-user-api-authentication/user-get-max-login-duration',
        data: requestData);

    var responseData = response.data;

    if (response.statusCode == 200) {
      if (responseData['status'] == 'success') {
        MaxLoginDurationClass maxLoginDurationData =
            MaxLoginDurationClass.fromJson(responseData);

        return maxLoginDurationData;
      }
    } else {}
  }

  static showSimpleMessage(
      String title, String message, String messageStatus, int durationInSec) {
    IconData icon = Icons.info_outline;
    Color color = Colors.blue;
    if (messageStatus == 'info') {
      icon = Icons.info_outline;
      color = Colors.blue;
      HapticFeedback.selectionClick();
    } else if (messageStatus == 'error') {
      icon = Icons.error_outline;
      color = Colors.red;
      HapticFeedback.heavyImpact();
    } else if (messageStatus == 'success') {
      icon = Icons.check_circle_outline;
      color = Colors.green;
      HapticFeedback.lightImpact();
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
      backgroundColor: Colors.black,
      shouldIconPulse: true,
      barBlur: 100,
      isDismissible: true,
      duration: Duration(seconds: durationInSec),
    );
  }
}

// https://app.quicktype.io/
class MaxLoginDurationClass {
  String status;
  bool accessTokenIsValid;
  String timeInputIntTextfield;
  String currentTimeInputText;

  MaxLoginDurationClass(
      {this.status,
      this.accessTokenIsValid,
      this.timeInputIntTextfield,
      this.currentTimeInputText});

  MaxLoginDurationClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    accessTokenIsValid = json['access_token_is_valid'];
    timeInputIntTextfield = json['timeInputIntTextfield'];
    currentTimeInputText = json['currentTimeInputText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['access_token_is_valid'] = this.accessTokenIsValid;
    data['timeInputIntTextfield'] = this.timeInputIntTextfield;
    data['currentTimeInputText'] = this.currentTimeInputText;
    return data;
  }
}

class GetUserDetailsClass {
  int userId;
  String userNicename;
  String userFirstName;
  String userLastName;
  String userRegistered;
  String userEmail;

  GetUserDetailsClass(
      {this.userId,
      this.userNicename,
      this.userFirstName,
      this.userLastName,
      this.userRegistered,
      this.userEmail});

  GetUserDetailsClass.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userNicename = json['user_nicename'];
    userFirstName = json['user_first_name'];
    userLastName = json['user_last_name'];
    userRegistered = json['user_registered'];
    userEmail = json['user_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_nicename'] = this.userNicename;
    data['user_first_name'] = this.userFirstName;
    data['user_last_name'] = this.userLastName;
    data['user_registered'] = this.userRegistered;
    data['user_email'] = this.userEmail;
    return data;
  }
}
