import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forum_app/common/widgets.dart';
import 'package:forum_app/models/user.dart';
import 'package:forum_app/views/screens/feed/post_detail.dart';
import 'package:forum_app/views/screens/feed/write_post.dart';
import 'package:forum_app/views/widgets/post_item.dart';
import 'package:page_transition/page_transition.dart';

class MyFeed extends StatefulWidget {
  final UserData myData;
  final ValueChanged<UserData> updateMyData;

  MyFeed({required this.myData, required this.updateMyData});

  @override
  _MyFeedState createState() => _MyFeedState();
}

class _MyFeedState extends State<MyFeed> {
  bool _isLoading = false;

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
          "thinQ",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').orderBy('postTimeStamp', descending: true).snapshots(),
        builder: (context,snapshot) {
          if (!snapshot.hasData) return const LinearProgressIndicator();
          return Stack(
            children: <Widget>[
              snapshot.data!.docs.isNotEmpty ?
              ListView(
                shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot data) { 
                  return PostItem(data: data, myData: widget.myData, updateMyData: widget.updateMyData, isFromPost: true, postItemAction: _moveToPostDetail, commentCount: data['postCommentCount']);
                }).toList(),
              ) : Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.error,color: Colors.grey[400],
                        size: 64,),
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text('There is no post yet',
                          style: TextStyle(fontSize: 16,color: Colors.grey[400]),
                          textAlign: TextAlign.center,),
                      ),
                    ],
                  )
                ),
              ),
              MyWidgets.circleLoader(_isLoading),
            ],
          );
        },
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

  void _moveToPostDetail(DocumentSnapshot data) {
    Navigator.push(context, PageTransition(child: PostDetail(postData: data, myData: widget.myData, updateMyData: widget.updateMyData), type: PageTransitionType.leftToRight));
  }
}