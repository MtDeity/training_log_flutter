import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:training_log_flutter/models/data.dart';
import 'package:training_log_flutter/models/exercise.dart';
import 'package:training_log_flutter/screens/add_lifts_screen.dart';

class TrainingScreen extends StatelessWidget {
  static const String id = 'training_screen';

  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context, data, child) {
        return Scaffold(
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
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: Image.asset(
                            'images/${snapshot.data[index].category}.png'),
                        title: Text('${snapshot.data[index].name}'),
                        onTap: () {
                          Navigator.of(context).push(
                            _createRoute(
                              snapshot.data[index].id,
                              snapshot.data[index].name,
                            ),
                          );
                        },
                      ),
                    );
                  },
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

Route _createRoute(int id, String name) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        AddLiftsScreen(id: id, name: name),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
