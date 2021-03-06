import 'package:flutter/material.dart';
import 'package:forum_app/common/widgets.dart';
import 'package:forum_app/views/screens/auth/register.dart';
import 'package:forum_app/views/screens/home.dart';
import 'package:forum_app/services/auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({ Key? key }) : super(key: key);
  
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // controllers for e-mail and password textfields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

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
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height / 20,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: size.width / 0.5,
                    child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios), onPressed: () {}),
                  ),
                  SizedBox(
                    height: size.height / 50,
                  ),
                  Container(
                    width: size.width / 1.1,
                    child: const Text(
                      "Welcome back",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: size.width / 1.1,
                    child: Text(
                      "Sign In to Continue!",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 10,
                  ),
                  Container(
                    width: size.width,
                    alignment: Alignment.center,
                    child: MyWidgets.textField(size, "email", Icons.account_box, emailController),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: MyWidgets.passwordField(size, "password", Icons.lock, passwordController),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 10,
                  ),
                  customButton(size),
                  SizedBox(
                    height: size.height / 40,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const Register())),
                    child: const Text(
                      "Create an account",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () async {

        setState(() {
          isLoading = true;
        });

        dynamic res = 
          await context.read<AuthService>().signIn(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          ); 
        
        if (res == "Signed in") {
          emailController.text = "";
          passwordController.text = "";
          
          setState(() {
            isLoading = false;
          });
          Navigator.push(
            context,
            PageTransition(child: const Home(), type: PageTransitionType.fade),
          );
        } else {
          passwordController.text = "";

          setState(() {
            isLoading = false;
          });
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Error"),
                content: Text(res),
                actions: [
                  TextButton(
                    child: const Text("Ok"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
          );
        }
      },
      child: Container(
          height: size.height / 14,
          width: size.width / 1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.cyan,
          ),
          alignment: Alignment.center,
          child: const Text(
            "Sign in",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )
        ),
    );
  }
}
