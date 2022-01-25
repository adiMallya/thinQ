import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forum_app/views/screens/wrapper.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(
      const Duration(
        seconds: 2
      ), 
      () => Navigator.push(
        context, 
        PageTransition(
          child: const Wrapper(), 
          type: PageTransitionType.fade)
      ),
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Center(
        child: RichText(
          text: const TextSpan(
            text: 'THIN',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 35.0,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "Q",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 50.0,
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
}