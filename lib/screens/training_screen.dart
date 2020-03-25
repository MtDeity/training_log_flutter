import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:training_log_flutter/models/data.dart';
import 'package:training_log_flutter/models/exercise.dart';

class TrainingScreen extends StatelessWidget {
  static const String id = 'training_screen';

  final items = List<String>.generate(1000, (i) => "Item $i");
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
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: Image.asset(
                            'images/${snapshot.data[index].category}.png'),
                        title: Text('${snapshot.data[index].name}'),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: Text("読み込み中"));
              }
            },
          ),
//          body: ListView.builder(
//            itemCount: data.exerciseList.length,
//            itemBuilder: (context, index) {
//              return Card(
//                child: ListTile(
//                  leading: Image.asset(
//                      'images/${data.exerciseList[index].category}.png'),
//                  title: Text('${data.exerciseList[index].name}'),
//                ),
//              );
//            },
//          ),
        );
      },
    );
  }
}
