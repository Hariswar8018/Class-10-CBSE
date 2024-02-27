import 'dart:io';
import 'dart:io';

import 'package:class11/main_pages/pdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' ;
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../main_pages/chapters.dart';

class DownloadedPDFList extends StatefulWidget {
  @override
  State<DownloadedPDFList> createState() => _DownloadedPDFListState();
}

class _DownloadedPDFListState extends State<DownloadedPDFList> {
  List<ChapterModel> list = [];
  int k = 1 ;
  String s = FirebaseAuth.instance.currentUser?.uid ??"tgh" ;
  late Map<String, dynamic> userMap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloaded PDFs'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").doc(s).collection("Pdfs").snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data?.map((e) => ChapterModel.fromJson(e.data())).toList() ?? [];
              return ListView.builder(
                itemCount: list.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {

                  return ChatUser(
                    user: list[index],
                    k : k ++ ,
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
  ChatUser({required this.user, required this.k,});
  ChapterModel user ;
  int k ;
  String s = FirebaseAuth.instance.currentUser?.uid ?? 'yhh' ;
  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: user.link == "NA" ? Colors.red : Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 0.05,
        ),
      ),
      child: ListTile(
          onTap : () async {
              Navigator.push(
                  context, PageTransition(
                  child: PdfV(pu: user.link, name: user.Name,), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 400)
              ));
              },
          tileColor: Colors.grey.shade50,
          leading: CircleAvatar(
            backgroundColor: ah(k),
            child : Text(k.toString()),
          ),
          subtitle: Row(
            children: [
              Container(
                  color: Colors.blue.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text("Advance Pdf Viewer"),
                  )),
              SizedBox(width : 8),
              Container(
                  color: Colors.grey.shade300,
                  child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text("Basic Pdf Viewer")) ),
            ],
          ),
          trailing : Text("19.8K Views"),
          title : Text(user.Name, style : TextStyle(fontWeight: FontWeight.w800))
      ),
    );
  }
  String hjl (String value){
    String firstCharacter = value.substring(0, 1);
    return firstCharacter ;
  }
  Color ah(int k){
    if( k == 0){
      return Colors.blue ;
    }else if ( k == 1){
      return Colors.greenAccent ;
    }else if( k == 2){
      return Colors.pinkAccent ;
    }else if( k == 3){
      return Colors.deepOrange ;
    }else if( k == 4){
      return Colors.purpleAccent ;
    }else if ( k == 5){
      return Colors.indigoAccent ;
    }else if ( k == 6){
      return Colors.yellowAccent ;
    }else{
      k = k - 6 ;
      return ah(k);
    }
  }
}
