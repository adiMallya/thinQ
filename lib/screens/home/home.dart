import 'package:flutter/material.dart';
import 'package:forum_app/screens/home/feed.dart';
import 'package:forum_app/screens/profile.dart';

class Home extends StatefulWidget { 
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  
  final PageController _pageController = PageController();
  int pageIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      pageIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: const [
          Feed(), Profile()
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
