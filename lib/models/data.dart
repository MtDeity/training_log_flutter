import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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

  bool liftShowSpinner = false;
  TextEditingController liftWeightController = TextEditingController();
  TextEditingController liftRepsController = TextEditingController();
  TextEditingController liftSetsController = TextEditingController();
  TextEditingController liftDateController = TextEditingController();

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

  void liftSpinnerToggle() {
    liftShowSpinner = !liftShowSpinner;
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

  void removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('id');
    prefs.remove('token');
  }

  void cleanController() {
    liftWeightController = TextEditingController();
    liftRepsController = TextEditingController();
    liftSetsController = TextEditingController();
    liftDateController = TextEditingController();
    liftDateController.text = DateFormat('yyyy/MM/dd').format(DateTime.now());
  }

  void updateDate(DateTime date) {
    liftDateController.text = DateFormat('yyyy/MM/dd').format(date);
  }

  Future<dynamic> liftData(int exerciseId) async {
    final http.Response response = await http.post(
      '$kUrl/exercises/$exerciseId/score',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        <String, Map<String, String>>{
          "score_params": {
            "weight": liftWeightController.text,
            "repetitions": liftRepsController.text,
            "sets": liftSetsController.text,
            "date": liftDateController.text,
          },
        },
      ),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }

  void lift(BuildContext context, int exerciseId) async {
    liftSpinnerToggle();
    try {
      final http.Response response = await http.post(
        '$kUrl/exercises/$exerciseId/score',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(
          <String, Map<String, String>>{
            "score_params": {
              "weight": liftWeightController.text,
              "repetitions": liftRepsController.text,
              "sets": liftSetsController.text,
              "date": liftDateController.text,
            },
          },
        ),
      );
      if (response.statusCode == 201) {
        Navigator.pop(context);
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      print(e);
    }
    liftSpinnerToggle();
  }

  Future<dynamic> getTrainingHistoryData() async {
    final http.Response response = await http.get(
      '$kUrl/users/$id/scores',
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

  Future<dynamic> getAllExercises() async {
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

  Future<List<DataRow>> getTrainingHistoryTable() async {
    dynamic allExercises = await getAllExercises();
    Map exercisesMap = Map();
    for (int i = 0; i < allExercises.length; i++) {
      String id = allExercises[i]['id'].toString();
      String name = allExercises[i]['name'].toString();
      exercisesMap[id] = name;
    }

    dynamic trainingHistoryData = await getTrainingHistoryData();
    List<DataRow> trainingHistoryList = [];
    for (int i = 0; i < trainingHistoryData.length; i++) {
      String exercise = trainingHistoryData[i]['exercise_id'].toString();
      String weight = trainingHistoryData[i]['weight'].toString();
      String reps = trainingHistoryData[i]['repetitions'].toString();
      String date = trainingHistoryData[i]['date'].toString();

      DataRow dataRow = DataRow(cells: [
        DataCell(Text(exercisesMap[exercise])),
        DataCell(Text(weight)),
        DataCell(Text(reps)),
        DataCell(Text(date)),
      ]);
      trainingHistoryList.add(dataRow);
    }
    return trainingHistoryList;
  }
}
