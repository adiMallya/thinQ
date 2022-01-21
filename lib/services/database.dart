import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forum_app/models/user.dart';

class DatabaseService {

  static Future<void> sendPostToDb(
    String postID, String postTitle, String postContent, UserData user) async {

    FirebaseFirestore.instance.collection('posts').doc(postID).set({
      '_id': postID,
      'userEmail': user.email,
      'postTimeStamp': DateTime.now().microsecondsSinceEpoch,
      'postTitle': postTitle,
      'postContent': postContent,
      'postVoteCount': 0,
      'postCommentCount': 0
    });
  }
}
