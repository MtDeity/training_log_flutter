import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:training_log_flutter/models/data.dart';
import 'package:training_log_flutter/screens/login_screen.dart';
import 'package:training_log_flutter/screens/registration_screen.dart';
import 'package:training_log_flutter/screens/training_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Data(),
      child: MaterialApp(
//        initialRoute: RegistrationScreen.id,
        initialRoute: LoginScreen.id,
        routes: {
          RegistrationScreen.id: (context) => RegistrationScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          TrainingScreen.id: (context) => TrainingScreen(),
        },
      ),
    );
  }
}
