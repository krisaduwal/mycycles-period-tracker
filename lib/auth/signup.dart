import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_cycles/auth/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}): super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  void createAccount() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();

    if(email == "" || password == "" || cPassword == "") {
      log("Please fill all the details!");
    }
    else if(password != cPassword) {
      log("Passwords do not match!");
    }
    else {
      //create new account
      try {
        UserCredential userCredential = await FirebaseAuth.instance.
        createUserWithEmailAndPassword(email: email, password: password);
        if(userCredential.user != null) {
          Navigator.pop(context);
        }
        log("user signed up");
      } on FirebaseAuthException catch(ex) {
        // if(ex.code == "weak-password") {
        //   //snackbar
        // }
        log(ex.code.toString());
      }
    

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("create an account"),
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

                  SizedBox(height: 10,),

                  TextField(
                    controller: cPasswordController,
                    decoration: InputDecoration(
                      labelText: "confirm password"
                    ),
                  ),

                  SizedBox(height: 20,),

                  CupertinoButton(
                     onPressed: () {
                       createAccount();
                     },
                    color: Colors.purple.shade200,
                    child: Text("Create Account"),
                  ),
                  SizedBox(height: 20,),
                  CupertinoButton(
                    onPressed: () {
                      Navigator.push(context, CupertinoPageRoute(
                          builder: (context) => LogIn()
                      ));
                    },

                    child: Text("Already have an account? Log In"),
                  ),



                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
