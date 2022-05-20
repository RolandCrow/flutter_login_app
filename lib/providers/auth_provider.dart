
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_login_app/utility/app_url.dart';
import 'package:flutter_login_app/utility/shared_preference.dart';
import 'package:http/http.dart';

import '../domain/user.dart';


enum Status {

  notLoggedIn,
  notRegistered,
  loggedIn,
  registered,
  authenticating,
  registering,
  loggedOut,
}

class AuthProvider extends ChangeNotifier {

  Status _loggedInStatus = Status.notLoggedIn;
  Status _registeredInStatus = Status.notRegistered;


  Status get loggedInStatus => _loggedInStatus;

  set loggedInStatus(Status value) {
    _loggedInStatus = value;
  }
  Status get registeredInStatus => _registeredInStatus;

  set registeredInStatus(Status value) {
    _registeredInStatus = value;
  }

  Future<FutureOr> register(String email, String password) async {
    final Map<String, dynamic> apiBodyData = {
      'email': email,
      'password': password,
    };

    return await post(
        AppUrl.register,
        body: json.encode(apiBodyData),
        headers: {'Content-Type': 'application/json'}
    ).then(onValue)
           .catchError(onError);
  }

  static Future<FutureOr> onValue (Response response) async{
      var result;

      final Map<String, dynamic> responseData = json.decode(response.body);
      if(response.statusCode == 200) {
        var userData = responseData['date'];
        User authUser = User.fromJson(responseData);

        UserPreference().saveUser(authUser);

        result = {
          'status': true,
          'message': 'Successfully registered',
          'data': authUser,
        };

      } else {
        result = {
          'status': false,
          'message': 'Successfully registered',
          'data' : responseData
        };
      }
      return result;
  }

  Future<Map<String, dynamic>> login(String email, String password) async{
        var result;

        final Map<String, dynamic> loginData = {
          'UserName': email,
          'Password': password,
        };

        _loggedInStatus = Status.authenticating;
        notifyListeners();

        Response response = await post(
          AppUrl.login,
          body: json.encode(loginData),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Basic ZGlzYXBpdXNlcjpkaXMjMTIz',
            'X-ApiKey' : 'ZGlzIzEyMw=='
          },
        );

        if(response.statusCode == 200) {
            final Map<String, dynamic> responseData = json.decode(response.body);

            var userData = responseData['Content'];
            User authUser = User.fromJson(userData);

            UserPreference().saveUser(authUser);

            _loggedInStatus = Status.loggedIn;
            notifyListeners();
            result = {'status': true, 'message': 'Successful', 'user': authUser};

        } else {
          _loggedInStatus = Status.notLoggedIn;
          notifyListeners();
          result = {
            'status': false,
            'message': json.decode(response.body)['error']
          };
        }



        return result;

  }

  static onError(error) {
    return {
      'status': false,
      'message': 'Unsuccessful Request',
      'data': error
    };
  }


}