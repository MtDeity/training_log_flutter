import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:training_log_flutter/constants.dart';

class Data extends ChangeNotifier {
  String loginEmail = '';
  String loginPassword = '';
  bool loginShowSpinner = false;

  void loginSpinnerToggle() {
    loginShowSpinner = !loginShowSpinner;
    notifyListeners();
  }

  Future<dynamic> loginData() async {
    final http.Response response = await http.post(
      '$kUrl/sign_in',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, Map<String, String>>{
        "sign_in_params": {
          "sign_in_text": loginEmail,
          "password": loginPassword,
        }
      }),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }

  void login() async {
    loginSpinnerToggle();
    try {
      final dynamic json = await loginData();
      if (json != null) {
        print(json['id']);
        print(json['token']);
      }
    } catch (e) {
      print(e);
    }
    loginSpinnerToggle();
  }
}
