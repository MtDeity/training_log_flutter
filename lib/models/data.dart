import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_log_flutter/constants.dart';
import 'package:training_log_flutter/models/exercise.dart';
import 'package:training_log_flutter/screens/training_screen.dart';

class Data extends ChangeNotifier {
  int id;
  String token;
  bool isLoggedIn = false;

  bool loginShowSpinner = false;
  String loginEmail = '';
  String loginPassword = '';

  bool registrationShowSpinner = false;
  String registrationEmail = '';
  String registrationPassword = '';
  String registrationPasswordConfirmation = '';
  bool isPublic = false;
  bool isPrivate = true;

  Future<bool> createIsLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      id = prefs.getInt('id') ?? 0;
      token = prefs.getString('token') ?? '';
      if (token.isNotEmpty) {
        isLoggedIn = true;
      }
    } catch (e) {
      print(e);
    }
    return isLoggedIn;
  }

  void loginSpinnerToggle() {
    loginShowSpinner = !loginShowSpinner;
    notifyListeners();
  }

  void registrationSpinnerToggle() {
    registrationShowSpinner = !registrationShowSpinner;
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

  void login(BuildContext context) async {
    loginSpinnerToggle();
    try {
      final dynamic json = await loginData();
      if (json != null) {
        writeToken(json);
        Navigator.pushNamed(context, TrainingScreen.id);
      }
    } catch (e) {
      print(e);
    }
    loginSpinnerToggle();
  }

  void writeToken(dynamic json) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', json['id']);
    prefs.setString('token', json['token']);

//        final int id = prefs.getInt('id') ?? 0;
//        final String token = prefs.getString('token') ?? '';
//        print(id);
//        print(token);
//
//    prefs.remove('id');
//    prefs.remove('token');
  }

  void privateSwitchDone(value) {
    isPublic = value;
    isPrivate = !value;
    notifyListeners();
  }

  Future<dynamic> registrationData() async {
    final http.Response response = await http.post(
      '$kUrl/sign_up',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, Map<String, String>>{
        "sign_up_params": {
          "name": registrationEmail.split('@')[0],
          "email": registrationEmail,
          "password": registrationPassword,
          "password_confirmation": registrationPasswordConfirmation,
          "user_private": isPrivate.toString(),
        }
      }),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }

  void registration(BuildContext context) async {
    registrationSpinnerToggle();

    try {
      final dynamic json = await registrationData();
      if (json != null) {
        writeToken(json);
        Navigator.pushNamed(context, TrainingScreen.id);
      }
    } catch (e) {
      print(e);
    }
    registrationSpinnerToggle();
  }

  Future<dynamic> getExercisesData() async {
    final http.Response response = await http.get(
      '$kUrl/exercises',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<List<Exercise>> getExercisesList() async {
    List<dynamic> exercises = await getExercisesData();
    List<Exercise> exerciseList = [];
    for (int i = 0; i < exercises.length; i++) {
      int id = exercises[i]['id'];
      String name = exercises[i]['name'];
      String category = exercises[i]['category'];

      switch (category) {
        case 'バーベル':
          category = 'barbell';
          break;
        case '自重':
          category = 'bodyweight';
          break;
        case 'ウェイトリフティング':
          category = 'weightlifting';
          break;
        case 'ダンベル':
          category = 'dumbbell';
          break;
        case 'マシン':
          category = 'machine';
          break;
        default:
          category = '';
      }

      Exercise exercise = Exercise(id: id, name: name, category: category);
      exerciseList.add(exercise);
    }
    return exerciseList;
  }
}
