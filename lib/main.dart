import 'package:CreativeWork2/screens/home_screen.dart';
import 'package:CreativeWork2/screens/siginin_screen.dart';
import 'package:CreativeWork2/screens/youtube.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat Youtube",
      debugShowCheckedModeBanner: false,
        initialRoute: SignInScreen.routeName,
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.deepOrange,
      ),
    
      routes: {
        SignInScreen.routeName: (context) => SignInScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        Youtube.routeName: (context) => Youtube(),
        
      },
    );
  }
}
