import 'package:class11/first/forgot.dart';
import 'package:class11/main.dart';
import 'package:class11/main_pages/navigation.dart';
import 'package:class11/model/usermode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_login_buttons/social_login_buttons.dart';


class SScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _confirmPasswordController2 = TextEditingController();
  String s = "Demo";
  String d = "Demo";
  @override
  void dispose() {
    _emailController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 70,),
                Image.asset("assets/10th cbse new.png", height: 70),
                SizedBox(height: 30,),
                Center(child: Text("Class 10 CBSE", style: TextStyle( color : Colors.black,fontFamily: "font1", fontSize: 30, fontWeight: FontWeight.w700))),
                Center(child: Text("Please sign up to our App to access features", style: TextStyle( color : Colors.black,fontFamily: "font1", fontSize: 17, fontWeight: FontWeight.w400))),
                SizedBox(height: 30,),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Your Email',  isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your School email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      d = value;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: ' Your New Password', isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please type your Password';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      s = value;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _confirmPasswordController2,
                  decoration: InputDecoration(
                    labelText: ' Confirm Your New Password', isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please type your Password';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      s = value;
                    });
                  },
                ),
                SizedBox(height: 20.0),
                SocialLoginButton(
                  backgroundColor:  Color(0xff50008e),
                  height: 40,
                  text: 'Create New Account',
                  borderRadius: 20,
                  fontSize: 21,
                  buttonType: SocialLoginButtonType.generalLogin,
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Signin you up ! Please Wait"),
                      ),
                    );
                    if (_confirmPasswordController.text ==
                        _confirmPasswordController2.text) {
                      try {
                        final credential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: _emailController.text,
                          password: _confirmPasswordController.text,
                        );
                        print(credential);
                        UserModel u = UserModel(Chess_Level: " ", Email: d,
                            Name: " ", Pic_link: " ", Bio: " ",
                            Draw: 0, Gender: " ",
                            Interest: " ", Language: " ",
                            Location: " ", Lose: 0,
                            Talk: " ", Won: 0, uid: credential.user!.uid);
                        await FirebaseFirestore.instance.collection("users").doc(credential.user!.uid).set(u.toJson());
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Signup successfull ! Welcome "),
                          ),
                        );
                        Restart.restartApp();
                        Restart.restartApp();
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'The password provided is too weak.'),
                            ),
                          );
                        } else if (e.code == 'email-already-in-use') {
                          print(
                              'The account already exists for that email.');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'The account already exists for that email.'),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '${e}'),
                          ),
                        );
                      }
                  } else {
                ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                content: Text(
                'Password do not match'),
                ),
                );
                } } ,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: () {
                      Navigator.pop(context);
                    }, child: Text("Not New? Login Now"),),
                    TextButton(onPressed: () {
                      Navigator.push(
                          context, PageTransition(
                          child: Forgot(), type: PageTransitionType.topToBottom, duration: Duration(milliseconds: 800)
                      ));
                    }, child: Text("Forgot Password?"),),
                  ],
                ),

                /* Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(onPressed: () {
                          Navigator.push(
                              context, PageTransition(
                              child: SignUp(), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
                          ));
                        }, child: Text("New User? Sign Up here"),),
                        TextButton(onPressed: () {
                          Navigator.push(
                              context, PageTransition(
                              child: Forgot(), type: PageTransitionType.topToBottom, duration: Duration(milliseconds: 800)
                          ));
                        }, child: Text("Forgot Password?"),),
                      ],
                    ),*/

                SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
