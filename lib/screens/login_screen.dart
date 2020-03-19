import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:training_log_flutter/constants.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'login_screen';
  String email = '';
  String password = '';
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 50.0,
            horizontal: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'ムキム記録',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50.0,
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                obscureText: false,
                onChanged: (value) {
                  email = value;
                },
                style: TextStyle(
                  fontSize: 18.0,
                ),
                decoration: kRegistrationInputDecoration.copyWith(
                  prefixIcon: Icon(Icons.email),
                  hintText: 'メールアドレスを入力してください',
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              TextField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                style: TextStyle(
                  fontSize: 18.0,
                ),
                decoration: kRegistrationInputDecoration.copyWith(
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'パスワードを入力してください',
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              RaisedButton(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'ログインする',
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
                  print(email);
                  print(password);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
