import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../widgets/button.dart';

class Sign_up extends StatelessWidget{
   Sign_up({super.key});

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();

   Future<void> signUpWithEmail(String email, String password, BuildContext context) async {
     try {
       await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).
       then((value) {
         Navigator.of(context).pushReplacementNamed('/Home');
       });
     } catch (e) {
       if (e is FirebaseAuthException) {
         if (e.code == 'email-already-in-use') {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This email is already in use')));
         } else {
           print('FirebaseAuthException: ${e.message}');
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This email is already in use')));
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
        title: const Text('Sign up'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset('background.jpeg' , fit: BoxFit.cover,),
          ),
          Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20,),
                    TextField(
                      controller: name ,
                      decoration: const InputDecoration(
                          hintText: 'Name' ,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                        fillColor: Colors.white ,
                        filled: true
                      ),
                    ),
                    const SizedBox(height: 10,),
                    TextField(
                      controller: phone ,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          hintText: 'Phone' ,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                        fillColor: Colors.white ,
                        filled: true
                      ),
                    ),
                    const SizedBox(height: 10,),
                    TextField(
                      controller: emailcontroller ,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: 'Email' ,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                        fillColor: Colors.white ,
                        filled: true
                      ),
                    ),
                    const SizedBox(height: 10,),
                    TextField(
                      controller: password ,
                      decoration: const InputDecoration(
                          hintText: 'Password' ,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                        fillColor: Colors.white,
                        filled: true
                      ),
                    ),
                    const SizedBox(height: 30,),
                    Button(
                        text: 'Register',
                        color: Colors.green,
                        textcolor: Colors.white,
                        onTap: (){
                          Navigator.of(context).pushNamed('/Sign in');
                          signUpWithEmail(emailcontroller.text, password.text,context);
                        }
                    ),
                  ],
                ) ,
              )
          ),
        ],
      )
    );
  }
}