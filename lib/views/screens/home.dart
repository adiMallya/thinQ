import 'package:flutter/material.dart';
import 'package:forum_app/models/user.dart';
import 'package:forum_app/views/screens/feed/my_feed.dart';
import 'package:forum_app/views/screens/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget { 
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  
  final PageController _pageController = PageController();
  late UserData myData;

  int pageIndex = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getMyData();
  }

  Future<void> _getMyData() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myData = UserData(
        name: prefs.getString('myName')!,
        email: prefs.getString('myEmail')!,
        myVoteList: prefs.getStringList('myVoteList'),
        myVoteCommentList: prefs.getStringList('myVoteCommentList')
      );
    });

    setState(() {
      isLoading = false;
    });
  }

  void updateMyData(UserData newMyData) {
    setState(() {
      myData = newMyData;
    });
  }

  void onTabTapped(int index) {
    setState(() {
      pageIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: isLoading
        ? Center(
            child: Container(
                height: size.height / 20,
                width: size.height / 20,
                child: const CircularProgressIndicator(),
              ),
          )
        : PageView(
            controller: _pageController,
            children: [
              MyFeed(myData: myData, updateMyData: updateMyData), 
              Profile(myData: myData, updateMyData: updateMyData)
            ],
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (page) {
              pageIndex = page;
            },
          ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: pageIndex,
        unselectedItemColor: Colors.grey[400],
        showSelectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Profile"
          ),
        ],
      ),
    );
  }
}