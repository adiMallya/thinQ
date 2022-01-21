import 'package:flutter/material.dart';
import 'package:forum_app/models/user.dart';
import 'package:forum_app/screens/feed/write_post.dart';
import 'package:page_transition/page_transition.dart';

class MyFeed extends StatefulWidget {
  final UserData myData;
  final ValueChanged<UserData> updateMyData;

  MyFeed({required this.myData, required this.updateMyData});

  @override
  _MyFeedState createState() => _MyFeedState();
}

class _MyFeedState extends State<MyFeed> {

  void _writePost() {
    Navigator.push(context, PageTransition(
      child: WritePost(myData: widget.myData),
      type: PageTransitionType.bottomToTop
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "theForum",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _writePost,
        child: const Icon(
          Icons.create,
          color: Colors.white,
        ),
      ),
    );
  }
}