import 'package:class11/card/blog_card.dart';
import 'package:class11/global.dart';
import 'package:class11/main.dart';
import 'package:class11/main/add_pdf.dart';
import 'package:class11/model/blog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../main_pages/blog.dart';

class Blog2 extends StatelessWidget {
  String what ;
  Blog2({super.key,required this.what });
  String s = FirebaseAuth.instance.currentUser?.uid ?? "h";
  List<BlogModel> list = [];

  late Map<String, dynamic> userMap;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Your Activities"),
          automaticallyImplyLeading: true,
      ),
      body : StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Updates10").where(what, arrayContains: s).snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data?.map((e) => BlogModel.fromJson(e.data())).toList() ?? [];
              if(list.isNotEmpty){
                return ListView.builder(
                  itemCount: list.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatUser(
                      c: list[index],
                    );
                  },
                );
              }else{
                return Center(
                  child : Text("Looks likes there's no Actiity ")
                );
              }


          }
        },
      ),
    );
  }
}