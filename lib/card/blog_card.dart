import 'package:class11/first/login.dart';
import 'package:class11/model/blog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Sh extends StatelessWidget {


  Sh({super.key, required this.c});
  BlogModel c ;
  String y = FirebaseAuth.instance.currentUser?.uid ?? "h";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white54,
        automaticallyImplyLeading: true,
        actions: [
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
          SizedBox(width : 19),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 250, width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(c.pictureLink),
                fit: BoxFit.cover
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(c.title, style : TextStyle(fontWeight: FontWeight.w800, fontSize: 21)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(c.para, style : TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
