import 'dart:math';

import 'package:flutter/material.dart';
import 'package:forum_app/common/utils.dart';
import 'package:forum_app/common/widgets.dart';
import 'package:forum_app/models/user.dart';
import 'package:forum_app/services/database.dart';

class WritePost extends StatefulWidget {
  final UserData myData;
  WritePost({required this.myData});

  @override
  _WritePostState createState() => _WritePostState();
}

class _WritePostState extends State<WritePost> {

  TextEditingController writeTitleController = TextEditingController();
  TextEditingController writePostController = TextEditingController();
  FocusNode writeTextFocus = FocusNode();
  bool _isLoading = false;

  void _postToDB() {
    setState(() {
      _isLoading = true;
    });
    // upload post data to dB
    String postID = Utils.getRandomString(8) + Random().nextInt(500).toString();
    DatabaseService.sendPostToDb(
      postID, 
      writeTitleController.text, 
      writePostController.text,
      widget.myData
    );

    setState(() {
      _isLoading = true;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap:() => Navigator.pop(context),
          child: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          TextButton(
            onPressed: _postToDB, 
            child: const Text(
              "Post",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: size.width,
                height: size.height - MediaQuery.of(context).viewInsets.bottom - 81,
                child: Padding(
                  padding: const EdgeInsets.only(right: 14.0, left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              "Title",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                            ),
                          ),
                          TextField(
                            autofocus: true,
                            focusNode: writeTextFocus,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "What is it about ?"
                            ),
                            controller: writeTitleController,
                            keyboardType: TextInputType.text,
                          )
                        ],
                      ),
                      Divider(height: 1, color: Colors.grey[600],),
                      TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Writing anything...",
                          hintMaxLines: 4,
                        ),
                        controller: writePostController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          MyWidgets.circleLoader(_isLoading),
        ],
      ),
    );
  }
}