import 'package:flutter/material.dart';
import 'package:forum_app/screens/auth/auth.dart';
import 'package:forum_app/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return home or auth widget
    return Auth();
  }
}
