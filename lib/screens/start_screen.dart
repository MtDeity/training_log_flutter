import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:training_log_flutter/models/data.dart';
import 'package:training_log_flutter/screens/login_screen.dart';
import 'package:training_log_flutter/screens/training_screen.dart';

class StartScreen extends StatelessWidget {
  static const String id = 'start_screen';

  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context, data, child) {
        return FutureBuilder(
            future: data.createIsLoggedIn(),
            builder: (
              BuildContext context,
              AsyncSnapshot<bool> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  print('snapshot.hasError');
                }
                if (snapshot.data) {
                  return TrainingScreen();
                } else {
                  return LoginScreen();
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            });
      },
    );
  }
}
