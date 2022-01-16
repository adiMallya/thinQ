import 'package:flutter/material.dart';
import 'package:forum_app/screens/auth/sign_in.dart';

class Auth extends StatefulWidget {
  const Auth({ Key? key }) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const SignIn(),
    );
  }
}