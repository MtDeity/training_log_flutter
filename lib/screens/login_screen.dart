import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:training_log_flutter/constants.dart';
import 'package:training_log_flutter/models/data.dart';
import 'package:training_log_flutter/screens/registration_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'login_screen';

  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context, data, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: kDarkBlue,
            title: Text('ログイン'),
          ),
          body: ModalProgressHUD(
            inAsyncCall: data.loginShowSpinner,
            child: Padding(
              padding: EdgeInsets.all(20.0),
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
                      data.loginEmail = value;
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
                      data.loginPassword = value;
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
                      data.login(context);
                    },
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RegistrationScreen.id);
                    },
                    child: Text(
                      '新規登録',
                      style: TextStyle(
                        color: kDarkBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
