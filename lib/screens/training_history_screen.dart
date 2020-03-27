import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:training_log_flutter/constants.dart';
import 'package:training_log_flutter/models/data.dart';
import 'package:training_log_flutter/models/exercise.dart';
import 'package:training_log_flutter/screens/training_screen.dart';

class TrainingHistoryScreen extends StatelessWidget {
  static const String id = 'training_history_screen';

  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context, data, child) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: kDarkBlue,
            onPressed: () {
              Navigator.pushNamed(context, TrainingScreen.id);
            },
          ),
          body: FutureBuilder(
            future: data.getExercisesList(),
            builder: (
              BuildContext context,
              AsyncSnapshot<List<Exercise>> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  print('snapshot.hasError');
                }
                return Container(
                  color: Colors.grey,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        );
      },
    );
  }
}
