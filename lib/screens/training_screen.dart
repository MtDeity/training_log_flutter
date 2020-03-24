import 'package:flutter/material.dart';

class TrainingScreen extends StatelessWidget {
  static const String id = 'training_screen';

  final items = List<String>.generate(10000, (i) => "Item $i");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${items[index]}'),
          );
        },
      ),
    );
  }
}
