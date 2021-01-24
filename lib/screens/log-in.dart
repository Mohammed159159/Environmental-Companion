import 'package:environmental_companion/screens/director.dart';
import 'package:environmental_companion/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
   var users = const {
    'dribbble@gmail.com': '12345',
    'hunter@gmail.com': 'hunter',
  };

  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _authUser(LoginData data) {
    print('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'Username not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'Username not exists';
      }
      return null;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterLogin(
            logo: "assets/logo.png",
            logoTag: "logo",
            title: "",
            theme: LoginTheme(
              primaryColor: Colors.lightGreen,
              accentColor: Colors.lightGreen,
              pageColorLight: Colors.lightGreenAccent,
              pageColorDark: Colors.greenAccent,
              cardTheme: CardTheme(
                elevation: 20
              ),
            ),
            onLogin: _authUser,
            onSignup: _authUser,
            onRecoverPassword: _recoverPassword,
            onSubmitAnimationCompleted: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Director(),
              ));
            },
          ),
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: Container(
          //     margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
          //     child: Text("Environmental Companion",
          //       style: h1,
          //     ),
          //   ),
          // )
        ],
      )
    );
  }
}