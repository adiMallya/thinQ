import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:forum_app/views/screens/auth/sign_in.dart';
import 'package:forum_app/views/screens/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return home or auth widget
    final firebaseuser = context.watch<User?>();
    
    if(firebaseuser != null){
      return const Home();
    }
    return const SignIn();
  }
}
