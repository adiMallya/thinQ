import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:forum_app/models/user.dart';
import 'package:forum_app/services/database.dart';
import 'package:forum_app/services/localStorage.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

class Utils {
  
  //To update post/comments vote count
  static Future<UserData> updateVoteCount(
    DocumentSnapshot data, bool isVotePost, UserData userData, ValueChanged<UserData> updateData, bool isPost  
  ) async {
    List<String> newVoteList = await LocalStorageService.saveVoteList(
      data[isPost ? 'postID' : 'commentID'], 
      userData.myVoteList, 
      isVotePost,
      isPost ? 'likeList' : 'commentList'
    );

    UserData updateUserData = UserData(
      email: userData.email,
      name: userData.name,
      myVoteList: isPost ? newVoteList : userData.myVoteList,
      myVoteCommentList: isPost ? userData.myVoteCommentList : newVoteList
    );
    updateData(updateUserData);

    isPost ? 
    await DatabaseService.updatePostVoteCount(data,isVotePost) : 
    await DatabaseService.updateCommentVoteCount(data,isVotePost);
    if (isPost) {
      await DatabaseService.voteToPost(data['postID'], userData, isVotePost);
    }
    return updateUserData;
  }

  //comment utils
  static String commentWithoutReplyUser(String commentString) {
    List<String> splitCommentString = commentString.split(' ');
    int commentUserNameLength = splitCommentString[0].length;
    String returnText = commentString.substring(commentUserNameLength,commentString.length);
    return returnText;
  }

  //helpers
  static String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      if (diff.inHours > 0) {
        time = diff.inHours.toString() + 'h';
      }else if (diff.inMinutes > 0) {
        time = diff.inMinutes.toString() + 'm';
      }else if (diff.inSeconds > 0) {
        time = 'now';
      }else if (diff.inMilliseconds > 0) {
        time = 'now';
      }else if (diff.inMicroseconds > 0) {
        time = 'now';
      }else {
        time = 'now';
      }
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      time = diff.inDays.toString() + 'd';
    } else if (diff.inDays > 6){
      time = (diff.inDays / 7).floor().toString() + 'w';
    }else if (diff.inDays > 29) {
      time = (diff.inDays / 30).floor().toString() + 'mo old';
    }else if (diff.inDays > 365){
      time = '${date.month} ${date.day}, ${date.year}';
    }
    return time;
  }

  static String getRandomString(int length) => String.fromCharCodes(
    Iterable.generate(
      length, (_) => _chars.codeUnitAt(Random().nextInt(_chars.length))
    )
  );
}