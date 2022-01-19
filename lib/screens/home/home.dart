import 'package:flutter/material.dart';
import 'package:forum_app/screens/home/feed.dart';
import 'package:forum_app/screens/profile.dart';
import 'package:forum_app/screens/splash_screen.dart';
import 'package:forum_app/services/auth.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget { 
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{
  
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void onTabTapped(int index) {
    setState(() {
      _tabController.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "theForum",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: <Widget>[
          // sign-out
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white,
            onPressed: () {
              context.read<AuthService>().signOut();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SplashScreen())
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          TabBarView(
            controller: _tabController,
            children: const [Feed(), Profile()]
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _tabController.index,
        unselectedItemColor: Colors.grey[400],
        showSelectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "My Feed"
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

