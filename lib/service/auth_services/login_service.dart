import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qixer/service/common_service.dart';
import 'package:qixer/view/home/landing_page.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:qixer/view/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService with ChangeNotifier {
  bool isloading = false;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  Future<bool> login(email, pass, BuildContext context, bool keepLoggedIn,
      {isFromLoginPage = true}) async {
    var connection = await checkConnection();
    if (connection) {
      setLoadingTrue();
      var data = jsonEncode({
        'email': email,
        'password': pass,
      });
      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        "Content-Type": "application/json"
      };

      var response = await http.post(Uri.parse('$baseApi/login'),
          body: data, headers: header);

      if (response.statusCode == 201) {
        if (isFromLoginPage) {
          OthersHelper()
              .showToast("Login successful", ConstantColors().successColor);
        }
        setLoadingFalse();

        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const LandingPage(),
          ),
        );

        String token = jsonDecode(response.body)['token'];
        int userId = jsonDecode(response.body)['users']['id'];

        if (keepLoggedIn) {
          saveDetails(email, pass, token, userId);
        } else {
          setKeepLoggedInFalseSaveToken(token);
        }

        return true;
      } else {
        print(response.body);
        //Login unsuccessful ==========>
        if (isFromLoginPage) {
          OthersHelper().showToast(
              "Invalid Email or Password", ConstantColors().warningColor);
        }
        setLoadingFalse();
        return false;
      }
    } else {
      //internet off
      return false;
    }
  }

  saveDetails(String email, pass, String token, int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
    prefs.setBool('keepLoggedIn', true);
    prefs.setString("pass", pass);
    prefs.setString("token", token);
    prefs.setInt('userId', userId);
    print('token is $token');
    print('user id is $userId');
  }

  setKeepLoggedInFalseSaveToken(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('keepLoggedIn', false);
    prefs.setString("token", token);
  }
}
