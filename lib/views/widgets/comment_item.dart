import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forum_app/common/utils.dart';
import 'package:forum_app/models/user.dart';

class CommentItem extends StatefulWidget {
  final DocumentSnapshot data;
  final UserData myData;
  final ValueChanged<UserData> updateMyData;
  final Size size;

  CommentItem({
    required this.data, 
    required this.myData, 
    required this.updateMyData, 
    required this.size, 
  });
  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  late UserData _currentMyData;

  @override
  void initState() {
    _currentMyData = widget.myData;
    super.initState();
  }

  void _updateVoteCount(bool isVotePost) async {
    UserData _newUserData = await Utils.updateVoteCount(
      widget.data, 
      isVotePost,
      widget.myData,
      widget.updateMyData,
      false
    );
    setState(() {
      _currentMyData = _newUserData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(widget.data['userName'],
                            style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(widget.data['commentContent'],maxLines: null,)
                          )
                        ],
                      ),
                    ),
                    width: widget.size.width - 90,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0)
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                    child: Container(
                      width: widget.size.width * 0.38,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(Utils.readTimestamp(widget.data['commentTimeStamp'])),
                          GestureDetector(
                            onTap: () => 
                            _updateVoteCount(_currentMyData.myVoteCommentList != null && 
                            _currentMyData.myVoteCommentList!.contains(widget.data['commentID']) ?
                            true : false),
                            child: Text('Vote',
                            style:TextStyle(
                              fontWeight: FontWeight.bold,
                              color:_currentMyData.myVoteCommentList != null && 
                              _currentMyData.myVoteCommentList!.contains(widget.data['commentID']) ?
                              Colors.cyan : Colors.grey[600])
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),

          widget.data['commentVoteCount'] > 0 ? Positioned(
            bottom: 10,
            right:0,
            child: Card(
                elevation:2.0,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.arrow_upward_rounded,size: 14,color: Colors.cyan,),
                      Text('${widget.data['commentVoteCount']}',style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                )
            ),
          ) : Container(),          
        ],
      ),
    );
  }
}