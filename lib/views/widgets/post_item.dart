import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forum_app/common/utils.dart';
import 'package:forum_app/models/user.dart';

class PostItem extends StatefulWidget {
  final DocumentSnapshot data;
  final UserData myData;
  final ValueChanged<UserData> updateMyData;
  final bool isFromPost;
  final Function postItemAction;
  final int commentCount;

  PostItem({
    required this.data, 
    required this.myData, 
    required this.updateMyData,
    required this.isFromPost,
    required this.postItemAction,
    required this.commentCount
  });
  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late UserData _currentMyData;
  late int _voteCount;

  @override
  void initState() {
    _currentMyData = widget.myData;
    _voteCount = widget.data['postVoteCount'];
    super.initState();
  }

  //vote and update count in local storage and DB
  void _updateVoteCount(bool isVotePost) async {
    UserData _newUserData = await Utils.updateVoteCount(
      widget.data, 
      widget.myData.myVoteList != null && 
      widget.myData.myVoteList!.contains(widget.data['postID']) ? true : false,
      widget.myData,
      widget.updateMyData,
      true
    );
    setState(() {
      _currentMyData = _newUserData;
    });
    setState(() {
      isVotePost ? _voteCount-- : _voteCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2.0,2.0,2.0,6),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () => widget.isFromPost ? widget.postItemAction(widget.data) : null,
                child: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.data['postTitle'], 
                          style: const TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            Utils.readTimestamp(widget.data['postTimeStamp']),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87
                            )
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => widget.isFromPost ? widget.postItemAction(widget.data) : null, 
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8,10,4,10),
                  child: Text(
                    (widget.data['postContent'] as String).length > 200
                    ? '${(widget.data['postContent'] as String).substring(0, 132)} ...' 
                    : widget.data['postContent'],
                    style: const TextStyle(fontSize: 16),
                    maxLines: 4,
                  ),
                ),
              ),
              Divider(height: 2, color: Colors.grey[400]),
              Padding(
                padding: const EdgeInsets.only(top: 6.0, bottom: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => 
                      _updateVoteCount(_currentMyData.myVoteList != null && 
                      _currentMyData.myVoteList!.contains(widget.data['postID']) ? 
                      true : false),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.arrow_upward_rounded,
                            size: 18,
                            color: widget.myData.myVoteList != null && 
                            widget.myData.myVoteList!.contains(widget.data['postID']) ? 
                            Colors.cyan : Colors.grey[400]),
                          Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Text(
                              '${widget.isFromPost ? widget.data['postVoteCount'] : _voteCount}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: widget.myData.myVoteList != null && 
                                widget.myData.myVoteList!.contains(widget.data['postID']) ? 
                                Colors.cyan : Colors.grey[400]
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {},
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.mode_comment,size: 18, color: Colors.cyan,),
                          Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Text(
                              '${widget.commentCount}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}