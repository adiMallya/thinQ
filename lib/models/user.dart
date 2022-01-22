class UserData {
  final String email;
  final String name;
  final List<String>? myVoteList;
  final List<String>? myVoteCommentList;

  UserData({
    required this.email,
    required this.name, 
    this.myVoteList, 
    this.myVoteCommentList
  });
}