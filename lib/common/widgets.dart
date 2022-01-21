import 'package:flutter/material.dart';

class MyWidgets {
  static Widget circleLoader(bool isLoading) {
    return isLoading ? Positioned(
      child: Container(
          child: const Center(
            child: CircularProgressIndicator(),
          ),
          color: Colors.white.withOpacity(0.7),
        ),
    ) : Container();
  }
}