// import 'dart:async';
//
// import 'package:chat/register/Login.dart';
// import 'package:chat/view/home_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class SplaceScreen extends StatefulWidget {
//   const SplaceScreen({super.key});
//
//   @override
//   State<SplaceScreen> createState() => _SplaceScreenState();
// }
//
// class _SplaceScreenState extends State<SplaceScreen> {
//
//   @override
//   void initState() {
//     super.initState();
//     Timer(Duration(seconds: 1), () {
//       var auth = FirebaseAuth.instance.currentUser;
//       if(auth != null){
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(uid: auth.uid,),));
//       }else{
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
//       }
//     },);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }


import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../register/Login.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(uid: currentUser.uid)),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body:Center(
        child: Text('Splash Screen',style: TextStyle(fontSize: 35,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
      )
    );
  }
}
