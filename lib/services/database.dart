import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forum_app/common/utils.dart';
import 'package:forum_app/models/user.dart';

class DatabaseService {

  static Future<void> sendPostToDb(
    String postID, String postTitle, String postContent, UserData myData) async {
    FirebaseFirestore.instance.collection('posts').doc(postID).set({
      'postID':postID,
      'userName':myData.name,
      'userEmail':myData.email,
      'postTimeStamp':DateTime.now().microsecondsSinceEpoch,
      'postTitle':postTitle,
      'postContent':postContent,
      'postVoteCount':0,
      'postCommentCount':0
    });
  }

  static Future<void> voteToPost(
    String postID, UserData userData, bool isVotePost) async {

    if (isVotePost) {
      DocumentReference voteReference = FirebaseFirestore.instance
                                        .collection('posts')
                                        .doc(postID)
                                        .collection('votes')
                                        .doc(userData.email);
      await FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
        transaction.delete(voteReference);
      });
    } else {
      await FirebaseFirestore.instance.collection('posts').doc(postID)
          .collection('votes').doc(userData.email).set({
        'userName':userData.name,
        'userEmail':userData.email,
      });
    }
  }

  static Future<void> updatePostVoteCount(
    DocumentSnapshot postData, bool isVotePost) async {
    postData.reference.update(
      {'postVoteCount': FieldValue.increment(isVotePost ? -1 : 1)});
  }

  static Future<void> updatePostCommentCount(DocumentSnapshot postData) async {
    postData.reference.update({'postCommentCount': FieldValue.increment(1)});
  }

  static Future<void> updateCommentVoteCount(
    DocumentSnapshot postData, bool isVotePost) async {
    postData.reference.update(
      {'commentVoteCount': FieldValue.increment(isVotePost ? -1 : 1)});
  }

  static Future<void> commentToPost(
    String toUserID, String postID, String commentContent, UserData userData) async {
    String commentID = Utils.getRandomString(8) + Random().nextInt(500).toString();

    FirebaseFirestore.instance.collection('posts').doc(postID)
      .collection('comments').doc(commentID).set({
        'commentID':commentID,
        'toUserID':toUserID,
        'userName':userData.name,
        'userEmail':userData.email,
        'commentTimeStamp':DateTime.now().millisecondsSinceEpoch,
        'commentContent':commentContent,
        'commentVoteCount':0
    });
  }
}