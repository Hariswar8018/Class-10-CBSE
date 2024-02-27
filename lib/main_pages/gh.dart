import 'package:class11/main_pages/chapters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class Page1 extends StatefulWidget {
  String i ;
   Page1({super.key, required this.i});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  List<SessionModel> list = [];
  late Map<String, dynamic> userMap;

  void initState(){
    setState((){

    });
  }
 int k = 0 ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text(widget.i),
      ),
        floatingActionButton:   FloatingActionButton(
            onPressed: (){
              Navigator.push(
                  context, PageTransition(
                  child: Add(id: widget.i,), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
              ));
            },
            child : Icon(Icons.add)
        ),
        body :  StreamBuilder(
        stream: FirebaseFirestore.instance.collection(widget.i).snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data?.map((e) => SessionModel.fromJson(e.data())).toList() ?? [];
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
                      id : widget.i ,
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
  String id ;
  ChatUser({required this.user, required this.k, required this.id});
  SessionModel user ;
  int k ;
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
  @override
  Widget build(BuildContext context){
    return ListTile(
      onTap : () async {
        Navigator.push(
            context, PageTransition(
            child: Chapter2( i: id, sd: user.id, name : user.Name), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 400)
        ));
        await FirebaseFirestore.instance.collection(id).doc(user.id).update({
          "o" : FieldValue.increment(1),
        });
        print("djmfjgkj");
      },
      leading: CircleAvatar(
        backgroundColor: ah(k),
        child : Text(hjl(user.Name), style : TextStyle(fontWeight: FontWeight.w900)),
      ),
      trailing : Text(fo(user.o)),
      title : Text(user.Name)
    );
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

  String hjl (String value){
    String firstCharacter = value.substring(0, 1);
    return firstCharacter ;
  }
}



class Add extends StatelessWidget {
  String id;

  Add({super.key, required this.id});

  final TextEditingController sessionNameController = TextEditingController();
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
                controller: sessionNameController,
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
                    CollectionReference collection = FirebaseFirestore.instance.collection(id);
                    String customDocumentId = DateTime.now().millisecondsSinceEpoch.toString(); // Replace with your own custom ID

                    await collection.doc(customDocumentId).set({
                      'Name': sessionNameController.text,
                      'id' : customDocumentId,
                      'o' : 0,
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

class SessionModel {
  SessionModel({
    required this.Name,
    required this.id,
    required this.o,
  });

  late final String Name;
  late final String id;
  late final int o ;

  SessionModel.fromJson(Map<String, dynamic> json) {
    Name = json['Name'] ?? 'samai';
    id = json['id'] ?? 'Xhqo6S2946pNlw8sRSKd';
    o = json['o'] ?? 0 ;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Name'] = Name;
    data['id'] = id ;
    data['o'] = o ;
    return data;
  }
}

