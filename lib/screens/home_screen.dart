
import 'package:ChatterBox/controller/firebasecontroller.dart';
import 'package:ChatterBox/helper/constants.dart';
import 'package:ChatterBox/helper/helperfunctions.dart';
import 'package:ChatterBox/screens/search.dart';
import 'package:ChatterBox/screens/siginin_screen.dart';
import 'package:ChatterBox/screens/views/myimageview.dart';
import 'package:ChatterBox/widgets/category_selector.dart';
import 'package:ChatterBox/widgets/favorite_contacts.dart';
import 'package:ChatterBox/widgets/recent_chats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';



class HomeScreen extends StatefulWidget {
  static const routeName = '/HomeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   _Controller con;
   User user;

   @override
  void initState() {
    
    super.initState();
    //getUserInfo(); //minor bug here that remembers old account
    con = _Controller(this);
  }

  getUserInfo() async{
    Constants.myName =  await HelperFunctions.getUserNameSharedPreference();
    
    setState(() {  
      print("getusername========== ${Constants.myName}");    
    });

  }

  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg['user'];

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          'Chats',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: con.search,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
                currentAccountPicture: ClipOval(
                    child: MyImageView.network(
                  imageUrl: user.photoURL,
                  context: context,
                )),
                accountEmail: Text(user.email),
                accountName: Text(user.displayName ?? 'N/A'),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('userInfo'), 
                onTap: getUserInfo, //this one works fine 
              ),
               ListTile(
                leading: Icon(Icons.settings),
                title: Text('Change Password'),
                onTap: con.resetPassword,
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sign Out With Google'),
                onTap: con.signOutGoogle,
              ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sign Out'),
              onTap: con.signOut,
            ),
          ],
        )
      ),
      body: Column(
        children: <Widget>[
          CategorySelector(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  FavoriteContacts(),
//                  RecentChats(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Controller {
  _HomeScreenState _state;
  _Controller(this._state);
   final GoogleSignIn googleSignIn = GoogleSignIn();

  void search() {
    _state.getUserInfo(); //to get new user info (workaround)
    Navigator.pushNamed(_state.context, SearchScreen.routeName);
  }

  void signOut() async {
    try {
      await FirebaseController.signOut();

    } catch (e) {
      print('signout exception:  ${e.message}');
    }
    Navigator.pushReplacementNamed(_state.context, SignInScreen.routeName);
  }

  void resetPassword() async {
    try {
      await FirebaseController.resetPassword(_state.user.email);
    } catch (e) {
      print(e.message);
    }
  }

   void signOutGoogle() async {
    await googleSignIn.signOut();
    Navigator.pushReplacementNamed(_state.context, SignInScreen.routeName);
    print("User Signed Out");
  }



}