import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:training_log_flutter/models/data.dart';
import 'package:training_log_flutter/screens/login_screen.dart';
import 'package:training_log_flutter/screens/registration_screen.dart';
import 'package:training_log_flutter/screens/start_screen.dart';
import 'package:training_log_flutter/screens/training_history_screen.dart';
import 'package:training_log_flutter/screens/training_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Data(),
      child: MaterialApp(
        initialRoute: StartScreen.id,
        routes: {
          StartScreen.id: (context) => StartScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          TrainingHistoryScreen.id: (context) => TrainingHistoryScreen(),
          TrainingScreen.id: (context) => TrainingScreen(),
        },
      ),
    );
  }
}
