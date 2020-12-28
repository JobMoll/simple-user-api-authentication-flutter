import 'dart:convert';
import 'package:dio/dio.dart' as dioCalls;
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    as secureStorage;
import 'package:get/get.dart';
import 'package:flutter/services.dart';

String baseDomainUrl = 'https://usercookieauthenticationapi.mollupbuilding.nl';

final dioSuaaCancelToken = dioCalls.CancelToken();
final dioSuaa = dioCalls.Dio(dioCalls.BaseOptions(
    baseUrl: baseDomainUrl,
    followRedirects: false,
    validateStatus: (status) {
      return status < 500;
    }))
  ..interceptors.add(dioCalls.LogInterceptor())
  ..httpClientAdapter = Http2Adapter(
    ConnectionManager(
      idleTimeout: 10000,
      // Ignore bad certificate
      onClientCreate: (_, config) => config.onBadCertificate = (_) => true,
    ),
  );

final dioSuaaRefreshAccessToken = dioCalls.Dio(
  dioCalls.BaseOptions(
      baseUrl: baseDomainUrl,
      followRedirects: false,
      validateStatus: (status) {
        return status < 500;
      }),
)
  ..interceptors.add(dioCalls.LogInterceptor())
  ..httpClientAdapter = Http2Adapter(
    ConnectionManager(
      idleTimeout: 10000,
      // Ignore bad certificate
      onClientCreate: (_, config) => config.onBadCertificate = (_) => true,
    ),
  );
final storage = new secureStorage.FlutterSecureStorage();

class SUAABasics {
  static requestNewAccessTokenInterceptor() {
    dioSuaa.interceptors.add(
      dioCalls.InterceptorsWrapper(
        onRequest: (dioCalls.RequestOptions options) {
          print('send request：${options.baseUrl}${options.path}');
        },
        onResponse: (dioCalls.Response response) async {
          if (response.statusCode == 401) {
            dioCalls.RequestOptions options = response.request;

            dioSuaa.lock();

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

                options.data["access_token"] = responseData['new_access_token'];
              } else {
                // refresh token is not valid

                dioSuaaCancelToken.cancel();

                dioSuaa.clear();
                dioSuaaRefreshAccessToken.clear();

                dioSuaa.unlock();

                SUAAAuth.userLogout();
              }
            }).whenComplete(() {
              dioSuaa.unlock();
            }).then((e) {
              //repeat
              return dioSuaa.request(options.path, options: options);
            });
          }
        },
      ),
    );
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

class SUAAUserDetails {
  static getUserData([bool initialLoad]) async {
    String accessToken =
        await storage.read(key: 'simple_user_api_authentication_access_token');

    Map<String, String> accessTokenData = {'access_token': accessToken};

    dioSuaa
        .post('/wp-json/simple-user-api-authentication/get-user-data',
            data: accessTokenData, cancelToken: dioSuaaCancelToken)
        .then((response) async {
      if (response.statusCode == 200) {
        if (initialLoad != true) {
          SUAABasics.showSimpleMessage('User data fetched!',
              'Here is the newest user data :)', 'success', 3);
        }
      }
    }).catchError((e) {
      if (dioCalls.CancelToken.isCancel(e)) {
        print('error: cancelled - get user data');
      }
    });
  }
}

class SUAASettings {
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
          SUAABasics.showSimpleMessage(responseData['title'],
              responseData['message'], responseData['status'], 3);
        }
      }
    }).catchError((e) {
      if (dioCalls.CancelToken.isCancel(e)) {
        print('error: cancelled - change user data');
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
          SUAABasics.showSimpleMessage(responseData['title'],
              responseData['message'], responseData['status'], 3);

          SUAAAuth.userLogout();
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

      if (response.statusCode == 200) {
        SUAABasics.showSimpleMessage(responseData['title'],
            responseData['message'], responseData['status'], 3);

        if (responseData['status'] == 'success') {
          SUAAAuth.userLogout();
        }
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
    } else {
      return throw ('Something wrong with getting max login duration...');
    }
    return throw ('Something wrong with getting max login duration...');
  }
}

class SUAAPasscode {
  static changePasscodeToUserAcccount(passcode) async {
    String accessToken =
        await storage.read(key: 'simple_user_api_authentication_access_token');

    Map<String, dynamic> requestData = {
      'access_token': accessToken,
      'new_passcode': passcode,
    };

    dioSuaa
        .post('/wp-json/simple-user-api-authentication/change-app-passcode',
            data: requestData)
        .then((response) async {
      var responseData = response.data;

      if (response.statusCode == 200) {
        if (responseData['status'] == 'success') {
          SUAABasics.showSimpleMessage(responseData['title'],
              responseData['message'], responseData['status'], 3);
        }
      }
    }).catchError((e) {
      if (dioCalls.CancelToken.isCancel(e)) {
        print('error: cancelled - change app passcode');
      }
    });
  }

  static getPasscodeToUserAcccount() async {
    String accessToken =
        await storage.read(key: 'simple_user_api_authentication_access_token');

    Map<String, String> requestData = {'access_token': accessToken};

    dioSuaa
        .post('/wp-json/simple-user-api-authentication/get-app-passcode',
            data: requestData)
        .then((response) async {
      var responseData = response.data;

      if (response.statusCode == 200) {
        if (responseData['status'] == 'success') {
          return responseData['app_passcode'];
        }
      }
    }).catchError((e) {
      if (dioCalls.CancelToken.isCancel(e)) {
        print('error: cancelled - get app passcode');
      }
    });
  }
}

class SUAAAuth {
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

        SUAABasics.showSimpleMessage('Your login is correct!',
            'You are successfully loggedin', 'success', 3);

        SUAABasics.requestNewAccessTokenInterceptor();

        Get.offNamed('/informationPage');
      } else {
        SUAABasics.showSimpleMessage(
            'Login problem...', responseData['message'], 'error', 3);
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
        SUAABasics.showSimpleMessage(responseData['title'],
            responseData['message'], responseData['status'], 3);
      }
    });
  }

  static forgotPassword(String usernameOrEmail) async {
    Map<String, String> requestData = {'username_or_email': usernameOrEmail};

    dioSuaa
        .post('/wp-json/simple-user-api-authentication/forgot-password',
            data: requestData)
        .then((response) async {
      var responseData = response.data;
      if (response.statusCode == 200) {
        SUAABasics.showSimpleMessage(responseData['title'],
            responseData['message'], responseData['status'], 3);
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

          SUAABasics.requestNewAccessTokenInterceptor();

          Get.offNamed("/informationPage");
        } else {
          userLogout();
        }
      });
    } else {
      userLogout();
    }
  }

  static userLogout([bool loadWithMessage]) async {
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

          if (loadWithMessage == true) {
            SUAABasics.showSimpleMessage('Successfully logged out',
                'You are succesfully logged out!', 'success', 3);
          }
        }
      }).catchError((e) {
        if (dioCalls.CancelToken.isCancel(e)) {
          print('error: cancelled - delete user tokens');
        }
      });
    } else {
      Get.offNamed("/loginPage");
    }
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
