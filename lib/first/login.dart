import 'package:class11/first/forgot.dart';
import 'package:class11/first/signup.dart';
import 'package:class11/main.dart';
import 'package:class11/main_pages/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:url_launcher/url_launcher.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String s = "Demo" ;
  String d = "Demo" ;

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
      body:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                    labelText: 'Your Password', isDense: true,
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
                SizedBox(height: 15,),
                SocialLoginButton(
                  backgroundColor:  Color(0xff50008e),
                  height: 40,
                  text: 'Login Now',
                  borderRadius: 20,
                  fontSize: 21,
                  buttonType: SocialLoginButtonType.generalLogin,
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Signin in you in ! Please Wait"),
                      ),
                    );
                    try {
                      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _emailController.text,
                        password: _confirmPasswordController.text,
                      ); //Try to Login the User
                      print(credential);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Signin successfull ! Welcome "),
                        ),
                      ); // Login Success
                      Restart.restartApp(); // Restart the App to call Listeners
                    }on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('No User found for this Email'),
                          ),
                        );
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Wrong password provided for that user.'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${e}"),
                          ),
                        );
                      }
                    }
                  },
                ),
                SizedBox(height: 16.0),
                SocialLoginButton(
                  backgroundColor:  Colors.white70,
                  height: 40,
                  text: 'Login with Google',
                  borderRadius: 20,
                  fontSize: 21,
                  buttonType: SocialLoginButtonType.google,
                  onPressed: () async {
                    signInWithGoogle(context);

                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: () {
                      Navigator.push(
                          context, PageTransition(
                          child: SScreen(), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
                      ));
                    }, child: Text("New User? Sign Up here"),),
                    TextButton(onPressed: () {
                      Navigator.push(
                          context, PageTransition(
                          child: Forgot(), type: PageTransitionType.topToBottom, duration: Duration(milliseconds: 800)
                      ));
                    }, child: Text("Forgot Password?"),),
                  ],
                ),

                SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<dynamic> signInWithGoogle(BuildContext context) async {
    const List<String> scopes = <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ];

    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: scopes,
    );

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      /* final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =  await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );*/
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Signin successfull"),
        ),
      );
      Restart.restartApp();
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      // TODO
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${e}"),
        ),
      );
      print('exception->$e');
    }
  }
}
