import 'package:flutter/material.dart';
import 'package:forum_app/models/user.dart';
import 'package:forum_app/views/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:forum_app/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final UserData myData;
  final ValueChanged<UserData> updateMyData;

  Profile({required this.myData, required this.updateMyData});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String _currentName;
  late String _email;

  @override
  void initState() {
    _currentName = widget.myData.name;
    _email = widget.myData.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "My Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircleAvatar(
              radius: 50,
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: (){
                _showDialog();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const Icon(
                    Icons.edit,
                    color: Colors.cyan,
                  )
                ],
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.email,
                  color: Colors.cyan,
                ),
                Text(
                  _email,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: (){
                context.read<AuthService>().signOut();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Wrapper()
                  )
                );
              },
              child: const Text("Log out"),
            )
          ],
        ),
      ),
    );
  }

  void _showDialog() async {
    TextEditingController _changeNameTextController = TextEditingController();
    await showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          contentPadding: const EdgeInsets.all(8.0),
          content: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Type your other name',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    icon: Icon(Icons.edit)),
                  controller: _changeNameTextController,
                )
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              }, 
              child: const Text("Cancel")
            ),
            TextButton(
              onPressed: () {
                _editMyName(_changeNameTextController.text);
                Navigator.pop(context);
              }, 
              child: const Text("Submit")
            )
          ],
        );
      }
    );
  }

  Future<void> _editMyName(String newName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('myName', newName);

    setState(() {
      _currentName = newName;
    });
    UserData updatedData = UserData(
      name: newName,
      email: widget.myData.email
    );
    widget.updateMyData(updatedData);
  }
}