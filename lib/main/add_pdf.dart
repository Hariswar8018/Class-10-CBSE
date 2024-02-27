import 'package:class11/model/blog.dart';
import 'package:class11/model/upload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class Add_Blog extends StatefulWidget {
  String id ;
  Add_Blog({super.key, required this.id});

  @override
  State<Add_Blog> createState() => _Add_BlogState();
}

class _Add_BlogState extends State<Add_Blog> {

  final TextEditingController Name = TextEditingController();
  final TextEditingController Paragraph = TextEditingController();
  final TextEditingController Name1 = TextEditingController();
  final TextEditingController Paragraph2 = TextEditingController();
  final TextEditingController link = TextEditingController();
  final TextEditingController linkp = TextEditingController();


  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Image Selected');
  }

  String pic = " ";
  String pic12 = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Add New Blog"),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        try {
                          Uint8List? _file = await pickImage(ImageSource
                              .gallery);
                          String photoUrl = await StorageMethods()
                              .uploadImageToStorage('users', _file!, true);
                          setState(() {
                            pic = photoUrl;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Logo Pic uploaded"),
                            ),
                          );
                        }catch(e){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${e}"),
                            ),
                          );
                        }
                      },
                      child: Container(
                          height: 90,
                          width: 200,
                          child: Image.network(
                            pic == " " ? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png" : pic,
                            fit: BoxFit.cover,
                          )
                      ),
                    ),
                    Container(
                      width : MediaQuery.of(context).size.width - 120 ,
                      child: Padding(
                        padding: const EdgeInsets.only( top :8.0, bottom : 15),
                        child: Center(child: Text( textAlign: TextAlign.center ,"Feature Image :  1080px x 720px")),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        try {
                          Uint8List? _file = await pickImage(ImageSource
                              .gallery);
                          String photoUrl = await StorageMethods()
                              .uploadImageToStorage('users', _file!, true);
                          setState(() {
                            pic12 = photoUrl;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Logo Pic uploaded"),
                            ),
                          );
                        }catch(e){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${e}"),
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: 80,
                        width: 80,
                        child: Image.network(
                          pic12 == " " ? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png" : pic12,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      width : 100,
                      child: Padding(
                        padding: const EdgeInsets.only( top :8.0, bottom : 15),
                        child: Text("Blog inner picture : 100cm x 100cm", textAlign: TextAlign.center,),
                      ),
                    ),
                  ],
                ),
                SizedBox(width : 20),
              ],
            ),
            Container(
              width : MediaQuery.of(context).size.width - 60 ,
              child: Padding(
                padding: const EdgeInsets.only( top :8.0, bottom : 15),
                child: Center(child: Text( textAlign: TextAlign.center ,"Upload School Principle / Authorize Signature or Stamp 1920 x 720")),
              ),
            ),
            d(
              Name,
              "Title of Content",
              "CBSE RESULT DECLARED on Cbse website",
              false,
            ),
            da(
              Paragraph,
              "Paragraph",
              "",
              false,
            ),

            d(
              Name1,
              "Title 2",
              " ",
              false,
            ),
            da(
              Paragraph2,
              "Paragraph 2",
              " ",
              true,
            ),
            d(
              link,
              "Paste Link",
              "https://ayush.starwish.fun",
              false,
            ),
            d(
              linkp,
              "Link Text",
              "View Website",
              false,
            ),
            Padding(
              padding: const EdgeInsets.only( left : 3.0, right : 3),
              child: Text("* Institute with this Email could Login and Upload Data"),
            ),
            Padding(
              padding: const EdgeInsets.only( left : 3.0, right : 3),
              child: Text("** Parents could find School with this UIDSE Code"),
            ),

          ],
        ),
      ),
      persistentFooterButtons: [
        SocialLoginButton(
          backgroundColor: Color(0xff50008e),
          height: 40,
          text: 'Add Blog',
          borderRadius: 20,
          fontSize: 21,
          buttonType: SocialLoginButtonType.generalLogin,
          onPressed: () async {
            String sg = DateTime.now().toString();
            BlogModel bg = BlogModel(
                pictureLink: pic, title: Name.text,
                date: sg, open: 0,
                para: Paragraph.text, picture: pic12,
                title1: Name1.text, para2: Paragraph2.text,
                link: link.text, linkp: linkp.text, boomark: [], activity: []);
            await FirebaseFirestore.instance.collection(widget.id).doc(sg).set(bg.toJson());
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget d(
      TextEditingController c,
      String label,
      String hint,
      bool number,
      ) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextFormField(
        controller: c,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          isDense: true,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please type It';
          }
          return null;
        },
      ),
    );
  }
  Widget da(
      TextEditingController c,
      String label,
      String hint,
      bool number,
      ) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextFormField(
        controller: c, minLines: 5, maxLines: 20,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          isDense: true,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please type It';
          }
          return null;
        },
      ),
    );
  }
}
