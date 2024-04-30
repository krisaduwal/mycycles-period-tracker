// import 'dart:math';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_cycles/auth/signup.dart';
import 'package:my_cycles/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var obscureText = true;

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
        final snackBar = SnackBar(
          margin: EdgeInsets.all(20),
          behavior: SnackBarBehavior.floating,
          content: Text('Logged In!',
              textAlign: TextAlign.center,
              style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Poppins')),
          backgroundColor: Colors.purple.shade300,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

      }catch(err){
        print("eta error");
        print(err);
      }
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Login",
        style: TextStyle(
          fontFamily: 'Allura',
          fontSize: 30
        ),),
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
                      hintText: "Email Address",
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Colors.purple,
                      )
                    ),
                  ),

                  SizedBox(height: 10,),

                  TextField(
                    controller: passwordController,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Colors.purple,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        child: obscureText ? const Icon(
                          Icons.visibility_off_outlined,
                          color: Colors.purple,
                        )
                        : const Icon(
                          Icons.visibility_outlined,
                          color: Colors.purple,
                        )
                      )
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
                  ),
                  Image(
                      image: AssetImage('assets/group1.png'), fit: BoxFit.cover),
                  Text("From women, for women", style: TextStyle(
                      fontFamily: 'Allura',
                      fontSize: 26,
                      color: Colors.purple.shade400
                  ),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
