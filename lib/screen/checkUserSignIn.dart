import 'package:application/screen/home.dart';
import 'package:application/screen/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckUserSignIn extends StatefulWidget {
  const CheckUserSignIn({Key? key}) : super(key: key);

  @override
  State<CheckUserSignIn> createState() => _CheckUserSignInState();
}

class _CheckUserSignInState extends State<CheckUserSignIn>  {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder:(context,snapshot){
          if(snapshot.hasData){
            return const HomeScreen();
          }else{
            return Login();
          }
        },
      ),
    );
  }
}
