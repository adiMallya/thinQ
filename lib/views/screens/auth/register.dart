import 'package:flutter/material.dart';
import 'package:forum_app/common/widgets.dart';
import 'package:forum_app/views/screens/home.dart';
import 'package:forum_app/services/auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({ Key? key }) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

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
                      icon: const Icon(
                        Icons.arrow_back_ios
                      ), 
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  ),
                  SizedBox(
                    height: size.height / 50,
                  ),
                  Container(
                    width: size.width / 1.1,
                    child: const Text(
                      "Welcome",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: size.width / 1.1,
                    child: Text(
                      "Create an account",
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
                  Container(
                    width: size.width,
                    alignment: Alignment.center,
                    child: MyWidgets.passwordField(size, "confirm password", Icons.lock, confirmPasswordController),
                  ),
                  SizedBox(
                    height: size.height / 10,
                  ),
                  customButton(size),
                  SizedBox(
                    height: size.height / 40,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      "I have already an account",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () async {
        if (emailController.text != "" && 
            passwordController.text != "" &&
            confirmPasswordController.text != "" &&
            passwordController.text == confirmPasswordController.text){
              setState(() {
                  isLoading = true;
                });

              dynamic res = await context.read<AuthService>().signUp(
                email: emailController.text.trim(), 
                password: passwordController.text.trim(),
              );

              if (res == "Signed up"){
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
                        ),
                      ],
                    );
                  },
                );

                emailController.text = "";
                passwordController.text = "";
                confirmPasswordController.text = "";
              }
            
        } else {
          if (passwordController.text != confirmPasswordController.text) {
            setState(() {
                  isLoading = false;
            });

            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text("Your passwords don't match!"),
                  actions: [
                    TextButton(
                      child: const Text('Ok'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );      
          } else {
            setState(() {
                  isLoading = false;
                });
                
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content:
                      const Text('Please fill in the required details!'),
                  actions: [
                    TextButton(
                      child: const Text('Ok'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          }
        }
      } ,
      child: Container(
          height: size.height / 14,
          width: size.width / 1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.cyan,
          ),
          alignment: Alignment.center,
          child: const Text(
            "Create Account",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }
}