// import 'dart:math';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_cycles/auth/signup.dart';
import 'package:my_cycles/home_screen.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if(email == "" || password == "") {

      //snackbar launa baki
      log("please fill all the fields");
    }
    else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password);
        if(userCredential.user != null) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement( context, CupertinoPageRoute(
              builder: (context) => MyCycles()
          ));
        }
      } on FirebaseAuthException catch(ex) {
        log(ex.code.toString());
      }
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Login"),
        backgroundColor: Colors.purple.shade100,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
                padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email Address"
                    ),
                  ),

                  SizedBox(height: 10,),

                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Password"
                    ),
                  ),

                  SizedBox(height: 20,),

                  CupertinoButton(
                      onPressed: () {
                        login();

                        // Navigator.push(context, CupertinoPageRoute(
                        //     builder: (context) => MyCycles()
                        // ));
                      },
                    color: Colors.purple.shade200,
                    child: Text("Log In"),
                  ),

                  SizedBox(height: 20,),

                  CupertinoButton(
                      onPressed: () {
                        Navigator.push(context, CupertinoPageRoute(
                            builder: (context) => SignUp()
                        ));
                      },
                    child: Text("Don't have an account? Create one"),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
