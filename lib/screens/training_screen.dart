import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:training_log_flutter/models/data.dart';

class TrainingScreen extends StatelessWidget {
  static const String id = 'training_screen';

  final items = List<String>.generate(1000, (i) => "Item $i");
  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context, data, child) {
        return Scaffold(
          body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Image.asset('images/barbell.png'),
                  title: Text('${items[index]}'),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
