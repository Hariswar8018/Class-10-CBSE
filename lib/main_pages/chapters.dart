import 'dart:io';

import 'package:class11/main_pages/pdf.dart';
import 'package:class11/main_pages/pdf_see.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:file_picker/file_picker.dart';


class Chapter2 extends StatefulWidget {
  String i ;
  String sd ;
  String name ;
  Chapter2({super.key, required this.i, required this.sd, required this.name});

  @override
  State<Chapter2> createState() => _Chapter1State();
}

class _Chapter1State extends State<Chapter2> {
  List<ChapterModel> list = [];
  late Map<String, dynamic> userMap;

  void initState(){
    setState((){

    });
  }
  int k = 1 ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text(widget.name),
      ),
      floatingActionButton:  FloatingActionButton(
          onPressed: (){
            Navigator.push(
                context, PageTransition(
                child: Add(id: widget.i, sd : widget.sd), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
            ));
          },
          child : Icon(Icons.add)
      ) ,
      body :  StreamBuilder(
        stream: FirebaseFirestore.instance.collection(widget.i).doc(widget.sd).collection("Subjects").snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data?.map((e) => ChapterModel.fromJson(e.data())).toList() ?? [];
              if(list.isEmpty){
                return Center(
                  child : Text("Looks like ! We haven't Uploaded yet")
                );
              }else{
                return ListView.builder(
                  itemCount: list.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {

                    return ChatUser(
                      user: list[index],
                      k : k ++ ,
                      id : widget.i,
                      sd : widget.sd,
                    );
                  },
                );
              }


          }
        },
      ),
    );
  }
}

class ChatUser extends StatelessWidget{
  ChatUser({required this.user, required this.k, required this.id, required this.sd});
  ChapterModel user ;
  int k ;
  String id ;
  String sd ;
  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: user.link == "NA" ? Colors.red : Colors.transparent,
        border: Border.all(
          color: Colors.black,
          width: 0.05,
        ),
      ),
      child: ListTile(
        onLongPress: (){

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Delete'),
                  content: Text('Delete the Pdf ! You must delete manually'),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance.collection(id).doc(sd).collection("Subjects").doc(user.id).delete();
                        Navigator.pop(context);
                      },
                      child: Text('Ok'),
                    ),
                  ],
                );
              },
            );


        },
          onTap : () async {
            if(user.link == "NA" ){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('NO PDF'),
                    content: Text('Please Upload PDF to do it'),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          try {
                            FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
                            if (result != null) {
                              File file = File(result.files.single.path!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Uploading your PDF'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                              final storageRef = FirebaseStorage.instance.ref();
                              final mountainsRef = storageRef.child("${user.Name}.pdf"); // Change the filename as needed

                              await mountainsRef.putFile(file);

                              String downloadUrl = await mountainsRef.getDownloadURL();

                              CollectionReference collection = FirebaseFirestore.instance.collection(id).doc(sd).collection("Subjects");

                              await collection.doc(user.id).update({
                                "link": downloadUrl,
                              });
                              Navigator.pop(context);
                            } else {
                              // User canceled file picking
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Sucess ! Pdf uploaded'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("$e"),
                                duration: Duration(seconds: 3),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: Text('Choose file'),
                      ),
                    ],
                  );
                },
              );
            }
            else{
              Navigator.push(
                  context, PageTransition(
                  child: PdfV(pu: user.link, name: user.Name,), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 400)
              ));
              print("djmfjgkj");
              await FirebaseFirestore.instance.collection(id).doc(sd).collection("Subjects").doc(user.id).update({
                "o" : FieldValue.increment(1),
              });
              String s = FirebaseAuth.instance.currentUser?.uid ?? "h";
              await FirebaseFirestore.instance.collection("users").doc(s).collection("Pdfs").doc(user.id).set(user.toJson());
            }
          },
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
                    child: Text("Advance Pdf Viewer", style : TextStyle(color : Colors.black)),
                  )),
              SizedBox(width : 8),
              InkWell(
                onTap: () async {
                  if(user.link == "NA"  ){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('NO PDF'),
                          content: Text('Please Upload PDF to do it'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                try {
                                  FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
                                  if (result != null) {
                                    File file = File(result.files.single.path!);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Uploading your PDF'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                    final storageRef = FirebaseStorage.instance.ref();
                                    final mountainsRef = storageRef.child("${user.Name}.pdf"); // Change the filename as needed

                                    await mountainsRef.putFile(file);

                                    String downloadUrl = await mountainsRef.getDownloadURL();

                                    CollectionReference collection = FirebaseFirestore.instance.collection(id).doc(sd).collection("Subjects");

                                    await collection.doc(user.id).update({
                                      "link": downloadUrl,
                                    });
                                    Navigator.pop(context);
                                  } else {
                                    // User canceled file picking
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Sucess ! Pdf uploaded'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                    Navigator.pop(context);
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("$e"),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                  Navigator.pop(context);
                                }
                              },
                              child: Text('Choose file'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  else{
                    Navigator.push(
                        context, PageTransition(
                        child: Pdfvv(pu: user.link, name: user.Name,), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 400)
                    ));
                    await FirebaseFirestore.instance.collection(id).doc(sd).collection("Subjects").doc(user.id).update({
                      "o" : FieldValue.increment(1),
                    });
                    print("djmfjgkj");
                    String s = FirebaseAuth.instance.currentUser?.uid ?? "h";
                    await FirebaseFirestore.instance.collection("users").doc(s).collection("Pdfs").doc(user.id).set(user.toJson());
                  }
                },
                child: Container(
                  color: Colors.grey.shade300,
                  child: Padding(
                      padding: const EdgeInsets.all(4.0),
                    child: Text("Basic Pdf Viewer", style : TextStyle(color : Colors.black))) ),
              ),
            ],
          ),
          trailing : Text(fo(user.open)),
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



class Add extends StatelessWidget {
  String id;
String sd ;
  Add({super.key, required this.id, required this.sd});

  final TextEditingController ChapterNameController = TextEditingController();
  String s = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Add New Subject"),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: TextFormField(
                controller: ChapterNameController,
                decoration: InputDecoration(
                  labelText: 'Subject Name',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please type your Password';
                  }
                  return null;
                },
                onChanged: (value) {
                  /*setState(() {
                    s = value;
                  });*/
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: SocialLoginButton(
                backgroundColor: Color(0xff50008e),
                height: 40,
                text: 'Add Subject Now',
                borderRadius: 20,
                fontSize: 21,
                buttonType: SocialLoginButtonType.generalLogin,
                onPressed: () async {
                  try {
                    CollectionReference collection = FirebaseFirestore.instance.collection(id).doc(sd).collection("Subjects");
                    String customDocumentId = DateTime.now().millisecondsSinceEpoch.toString(); // Replace with your own custom ID

                    await collection.doc(customDocumentId).set({
                      'Name': ChapterNameController.text,
                      'id' : customDocumentId,
                      'o' : 0 ,
                      // Add more fields as needed
                    });

                    Navigator.pop(context);
                  } catch (e) {
                    print('${e}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${e}'),
                      ),
                    );
                  }
                  ;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChapterModel {
  ChapterModel({
    required this.Name,
    required this.id,
    required this.link,
    required this.open,
  });

  late final String Name;
  late final String id;
  late final String link;
  late final int open ;

  ChapterModel.fromJson(Map<String, dynamic> json) {
    Name = json['Name'] ?? 'samai' ;
    id = json['id'] ?? 'Xhqo6S2946pNlw8sRSKd' ;
    link = json['link'] ?? "NA" ;
    open = json["o"] ?? 0 ;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Name'] = Name;
    data['o'] = open ;
    data['id'] = id ;
    data['link'] = link ;
    return data;
  }
}

