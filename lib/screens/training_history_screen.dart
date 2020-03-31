import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:training_log_flutter/constants.dart';
import 'package:training_log_flutter/models/data.dart';
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
            future: data.getTrainingHistoryTable(),
            builder: (
              BuildContext context,
              AsyncSnapshot<dynamic> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  print('snapshot.hasError');
                }
                return Scaffold(
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(
                              label: Text('種目'),
                            ),
                            DataColumn(
                              label: Text('重量'),
                            ),
                            DataColumn(
                              label: Text('レップ'),
                            ),
                            DataColumn(
                              label: Text('日付'),
                            ),
                          ],
                          rows: snapshot.data,
                        ),
                      ),
                    ),
                  ),
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
