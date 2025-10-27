import 'package:application/screen/admin.dart';
import 'package:application/screen/chat.dart';
import 'package:application/screen/market.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:application/screen/checkUserSignIn.dart';
import 'package:application/screen/home.dart';
import 'package:application/screen/location.dart';
import 'package:application/screen/login.dart';
import 'package:application/screen/sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    CheckUserSignIn(),
    Chat(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      routes: <String, WidgetBuilder>{
        '/Sign in': (BuildContext context) => Login(),
        '/Sign up': (BuildContext context) => Sign_up(),
        '/Home': (BuildContext context) => HomeScreen(),
        '/CheckUserSignIn': (BuildContext context) => CheckUserSignIn(),
        '/Chat': (BuildContext context) => Chat(),
        '/Market': (BuildContext context) => Market(),
        '/Admin': (BuildContext context) => Admin(),
      },
      home: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black12,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home , color: Colors.green,),
              label: 'Home',
              backgroundColor: Colors.black
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat , color: Colors.green,),
              label: 'Chat',
              backgroundColor: Colors.black
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
