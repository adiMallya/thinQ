import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService{
  static Future<List<String>> saveVoteList(
    String postID, 
    List<String>? myVoteList, 
    bool isVotePost, 
    String updateType) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> newVoteList = myVoteList ?? [];
    if (myVoteList == null) {
      newVoteList.add(postID);
    } else {
      if (isVotePost) {
        myVoteList.remove(postID);
      } else {
        myVoteList.add(postID);
      }
    }
    prefs.setStringList(updateType, newVoteList);
    return newVoteList;
  }
}