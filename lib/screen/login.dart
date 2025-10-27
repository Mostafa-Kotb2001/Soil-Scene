import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/button.dart';

class Login extends StatelessWidget{
  Login({super.key});

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> signInWithEmail(String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
      .then((value) {
        Navigator.of(context).pushReplacementNamed('/Home');
      });
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User not found')));
        } else if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wrong password')));
        } else {
          print('FirebaseAuthException: ${e.message}');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('user not found')));
        }
      } else {
        print('Unknown error: $e');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('An unknown error occurred')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset('background.jpeg' , fit: BoxFit.cover,)
          ),
          Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    TextField(
                      controller: emailcontroller ,
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                          hintText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        fillColor: Colors.white ,
                        filled: true
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextField(
                      controller: password ,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                          hintText: 'Password' ,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                        fillColor: Colors.white ,
                        filled: true
                      ),
                    ),
                    const SizedBox(height: 30,),
                    Button(
                      text: 'SIGN IN',
                      color: Colors.green,
                      textcolor: Colors.black,
                      onTap:() {signInWithEmail(emailcontroller.text, password.text, context);} ,
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      child: Text('If you want to sign up' , style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black ),),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('/Sign up');
                          print('Clicked on the word');
                        },
                        child: const Text(
                          'Click Here',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ),
        ],
      )
    );
  }
}