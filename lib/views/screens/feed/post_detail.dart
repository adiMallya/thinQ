import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forum_app/models/user.dart';
import 'package:forum_app/services/database.dart';
import 'package:forum_app/views/widgets/comment_item.dart';
import 'package:forum_app/views/widgets/post_item.dart';

class PostDetail extends StatefulWidget {
  final DocumentSnapshot postData;
  final UserData myData;
  final ValueChanged<UserData> updateMyData;

  PostDetail({required this.postData, required this.myData, required this.updateMyData});

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  final TextEditingController _msgTextController = TextEditingController();
  late UserData currentMyData;
  String? _replyUserID;
  final FocusNode _writingTextFocus = FocusNode();

  @override
  void initState() {
    currentMyData = widget.myData;
    _msgTextController.addListener(_msgTextControllerListener);
    super.initState();
  }
  
  void _msgTextControllerListener() {
    if (_msgTextController.text.isEmpty || _msgTextController.text.split(" ")[0] != _replyUserID) {
      _replyUserID = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Post Detail',
          style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').doc(widget.postData['postID']).collection('comments').orderBy('commentTimeStamp',descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const LinearProgressIndicator();
          return Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2.0,2.0,2.0,6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            PostItem(data: widget.postData, myData: widget.myData, updateMyData: widget.updateMyData, isFromPost: false, postItemAction: (){}, commentCount: snapshot.data!.docs.length),
                            snapshot.data!.docs.isNotEmpty ?
                            ListView(
                              primary: false,
                              shrinkWrap: true,
                              children: snapshot.data!.docs.map((DocumentSnapshot data) { 
                                return CommentItem(data: data, myData: widget.myData, updateMyData: widget.updateMyData, size: size);
                              }).toList(),
                            ) : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildTextComposer(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                autofocus: true,
                focusNode: _writingTextFocus,
                controller: _msgTextController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration.collapsed(
                    hintText: "Write a response"),
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  _handleSubmitted(_msgTextController.text);
                }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmitted(String text) async {
    try {
      await DatabaseService.commentToPost(_replyUserID ?? widget.postData['userName'],widget.postData['postID'], _msgTextController.text, widget.myData);
      await DatabaseService.updatePostCommentCount(widget.postData);
      FocusScope.of(context).requestFocus(FocusNode());
      _msgTextController.text = '';
    }catch(e){
      print('error to submit comment');
    }
  }    
}