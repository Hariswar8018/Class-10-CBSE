import 'package:class11/global.dart';
import 'package:class11/main.dart';
import 'package:flutter/material.dart';
import 'package:class11/card/blog_card.dart';
import 'package:class11/first/login.dart';
import 'package:class11/global.dart';
import 'package:class11/main.dart';
import 'package:class11/main/add_pdf.dart';
import 'package:class11/model/blog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notify extends StatefulWidget {

  @override
  State<Notify> createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  bool n = false ;

  void initState(){
    sb();

    setState((){

    });
  }

  sb() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool dark = prefs.getBool('dark') ?? false ;
    n = dark ;
  }

  List<BlogModel> list = [];

  late Map<String, dynamic> userMap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Notifications"),
          actions : [
            IconButton(icon : Icon(Icons.search), onPressed : (){

            }),
            SizedBox(width : 10),
          ]
      ),
      floatingActionButton:  FloatingActionButton(
        child: Icon(Icons.add), onPressed: (){
        Navigator.push(
            context, PageTransition(
            child: Add_Blog (id: 'Notify10',), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
        ));
      },
      ) ,
      drawer : Df.buildDrawer(context, n),
      body : StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Notify10").snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data?.map((e) => BlogModel.fromJson(e.data())).toList() ?? [];
              return ListView.builder(
                itemCount: list.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChatUser(
                    c: list[index],
                  );
                },
              );

          }
        },
      ),
    );
  }
}

class ChatUser extends StatelessWidget{
  BlogModel c ;
  ChatUser({required this.c});
  String y = FirebaseAuth.instance.currentUser?.uid ?? "h";
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onLongPress: () async {

            await FirebaseFirestore.instance.collection("Notify10").doc(c.date).delete();

        },
        onTap: () async {
          String y = FirebaseAuth.instance.currentUser?.uid ?? "h";
          await FirebaseFirestore.instance.collection("Notify10").doc(c.date).update({
            "open" : FieldValue.increment(1),
          });
          Navigator.push(
              context, PageTransition(
              child: Sh(c : c), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 300)
          ));
        },
        child: Container(
          height: 260,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),   // Top left corner rounded
              topRight: Radius.circular(20),  // Top right corner rounded
              bottomLeft: Radius.circular(10),   // Top left corner rounded
              bottomRight: Radius.circular(10),  // Top right corner rounded
            ),
            border: Border.all(
              color: Colors.grey.shade200, // Border color
              width: 1, // Border width
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Shadow color
                spreadRadius: 5, // Spread radius
                blurRadius: 7, // Blur radius
                offset: Offset(0, 3), // Offset of the shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 160,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),   // Top left corner rounded
                      topRight: Radius.circular(20),  // Top right corner rounded
                    ),
                    image: DecorationImage(
                        image: NetworkImage(
                            c.pictureLink
                        ), fit: BoxFit.cover
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left : 9.0, right : 9, top : 5),
                child: Text(c.title, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18), maxLines: 2,),
              ),
              Padding(
                padding: const EdgeInsets.only(left : 9.0, right : 9),
                child: Divider(thickness: 0.5,),
              ),
              Row(
                children: [
                  SizedBox(width : 15),
                  Icon(Icons.calendar_month, size: 18, color: Colors.grey,),
                  SizedBox(width : 3),
                  Text(c.date),
                  SizedBox(width : 25),
                  Icon(Icons.remove_red_eye, size: 18, color: Colors.grey,),
                  SizedBox(width : 3),
                  Text(fo(c.open)),
                  Spacer(),
                  InkWell(
                      onTap: () async {
                        if(y == "h"){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('Login to use this Feature'),
                            duration: const Duration(seconds: 5),
                            action: SnackBarAction(
                              label: 'Login Now',
                              onPressed: () {
                                Navigator.push(
                                    context, PageTransition(
                                    child: LoginScreen(), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
                                ));
                              },
                            ),
                          ));
                        }else{
                          if(c.boomark.contains(y)){
                            await FirebaseFirestore.instance.collection("Updates10").doc(c.date).update({
                              "bookmark" : FieldValue.arrayRemove([y]),
                            });
                          }else{
                            await FirebaseFirestore.instance.collection("Updates10").doc(c.date).update({
                              "bookmark" : FieldValue.arrayUnion([y]),
                            });
                          }
                        }
                      },
                      child: c.boomark.contains(y) ? Icon(Icons.bookmark) : Icon(Icons.bookmark_add_outlined)),
                  SizedBox(width : 9),
                  Icon(Icons.share),
                  SizedBox(width : 15),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  String fo(int value) {
    if (value < 1000) {
      return value.toString(); // Return the value as is if it's less than 1000
    } else if (value < 1000000) {
      // Format the value with K suffix if it's between 1000 and 999999
      return (value / 1000).toStringAsFixed(1) + 'K';
    } else {
      // Format the value with M suffix if it's greater than or equal to 1000000
      return (value / 1000000).toStringAsFixed(1) + 'M';
    }
  }
}