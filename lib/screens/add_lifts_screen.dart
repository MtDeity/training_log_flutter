import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:training_log_flutter/constants.dart';
import 'package:training_log_flutter/models/data.dart';

class AddLiftsScreen extends StatelessWidget {
  AddLiftsScreen({
    @required this.id,
    @required this.name,
  });

  final int id;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context, data, child) {
        data.cleanController();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: kDarkBlue,
            title: Text(name),
          ),
          body: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  controller: data.liftWeightController,
                  keyboardType: TextInputType.numberWithOptions(
                    signed: false,
                    decimal: true,
                  ),
                  obscureText: false,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                  decoration: kRegistrationInputDecoration.copyWith(
                    hintText: '重量（例：62.5）',
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextField(
                  controller: data.liftRepsController,
                  keyboardType: TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  obscureText: false,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                  decoration: kRegistrationInputDecoration.copyWith(
                    hintText: 'レップ数（例：8）',
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextField(
                  controller: data.liftSetsController,
                  keyboardType: TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  obscureText: false,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                  decoration: kRegistrationInputDecoration.copyWith(
                    hintText: 'セット数（例：3）',
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextField(
                  controller: data.liftDateController,
                  keyboardType: TextInputType.datetime,
                  obscureText: false,
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 5),
                      lastDate: DateTime(DateTime.now().year + 1),
                    );

                    if (selectedDate != null) {
                      data.updateDate(selectedDate);
                    }
                  },
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                  decoration: kRegistrationInputDecoration,
                ),
                SizedBox(
                  height: 15.0,
                ),
                RaisedButton(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    '記録する',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13.0),
                  ),
                  color: kDarkBlue,
                  onPressed: () {
                    data.lift(context, id);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
