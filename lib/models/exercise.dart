import 'package:flutter/material.dart';

class Exercise {
  Exercise({
    @required this.id,
    @required this.name,
    @required this.category,
  });

  final int id;
  final String name;
  final String category;
}
