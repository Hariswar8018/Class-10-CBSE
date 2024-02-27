
import 'package:class11/main.dart';
import 'package:class11/main_pages/blog.dart';
import 'package:class11/main_pages/result.dart';
import 'package:class11/main_pages/stless.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
    final user = FirebaseAuth.instance.currentUser;

  int currentTab=0;
  final Set screens ={
    MyHomePage(),
    Blog(),
    Result(),
    Notify(),
  };
  final PageStorageBucket bucket = PageStorageBucket();

  dynamic selected ;
  var heart = false;
  PageController controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  Widget currentScreen = MyHomePage();
  @override
  Widget build(BuildContext context){
    return WillPopScope(
        onWillPop: () async {
          // Show the alert dialog and wait for a result
          bool exit = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Exit App'),
                content: Text('Are you sure you want to exit?'),
                actions: [
                  ElevatedButton(
                    child: Text('No'),
                    onPressed: () {
                      // Return false to prevent the app from exiting
                      Navigator.of(context).pop(false);
                    },
                  ),
                  ElevatedButton(
                    child: Text('Yes'),
                    onPressed: () async {
                      SystemNavigator.pop() ;
                      // Return true to allow the app to exit
                      Navigator.of(context).pop(true);

                    },
                  ),
                ],
              );
            },
          );

          // Return the result to handle the back button press
          return exit ?? false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: PageStorage(
            child: currentScreen,
            bucket: bucket,
          ),
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 4, color: Colors.white, surfaceTintColor: Colors.white,
            shadowColor:  Colors.white,
            child: Container(
              height: 20, color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                      minWidth: 25, onPressed: (){
                    setState(() {
                      currentScreen = MyHomePage();
                      currentTab = 0;
                    });
                  },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home,
                            color: currentTab == 0? Colors.black : Colors.grey, size: 23,
                          ),
                          Text("Home", style: TextStyle(color: currentTab == 0?  Colors.black :Colors.grey, fontSize: 12))
                        ],
                      )
                  ),
                  MaterialButton(
                      minWidth: 25, onPressed: (){
                    setState(() {
                      currentScreen = Blog();
                      currentTab = 1;
                    });
                  },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.newspaper,
                            color: currentTab == 1? Colors.black:Colors.grey, size: 23,
                          ),
                          Text("Updates", style: TextStyle(color: currentTab == 1? Colors.black:Colors.grey, fontSize: 12))
                        ],
                      )
                  ),
                  MaterialButton(
                      minWidth: 25, onPressed: (){
                    setState(() {
                      currentScreen = Result();
                      currentTab = 2;
                    });
                  },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.leaderboard,
                            color: currentTab == 2? Colors.black:Colors.grey, size: 23,
                          ),
                          Text("Result", style: TextStyle(color: currentTab == 2? Colors.black:Colors.grey, fontSize: 12))
                        ],
                      )
                  ),
                  MaterialButton(
                    minWidth: 25, onPressed: (){
                    setState(() {
                      currentScreen = Notify();
                      currentTab = 3;
                    });
                  },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                        Icons.notifications_on,
                          color: currentTab == 3? Colors.black:Colors.grey,size: 23,
                        ),
                        Text("Notify", style: TextStyle(color: currentTab == 3? Colors.black :Colors.grey,fontSize: 12))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}