import 'package:class11/global.dart';
import 'package:class11/main_pages/gh.dart';
import 'package:class11/main_pages/navigation.dart';
import 'package:class11/model/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' ;
import 'package:class11/firebase_options.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:class11/adhelp.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:day_night_switcher/day_night_switcher.dart';

import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(); //initilization of Firebase app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool dark = prefs.getBool('dark') ?? false ;
  runApp( MyApp( dark : dark ) );
}

class MyApp extends StatelessWidget {
  bool dark ;
  MyApp({super.key, required this.dark});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class 10 CBSE', debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        // Customize light theme colors
        scaffoldBackgroundColor: dark ? Colors.grey[900] : Colors.white,
        // Adjust text and icon colors for light theme
        textTheme: ThemeData.light().textTheme.copyWith(
          bodyText1: TextStyle(color: dark ? Colors.white : Colors.black),
          // Adjust other text styles as needed
        ),
        iconTheme: IconThemeData(color: dark ? Colors.white : Colors.black),
        // Adjust other icon colors as needed
      ),
      darkTheme: ThemeData.dark().copyWith(
        // Customize dark theme colors
        scaffoldBackgroundColor: dark ? Colors.grey[900] : Colors.black,
        // Adjust text and icon colors for dark theme
        textTheme: ThemeData.dark().textTheme.copyWith(
          bodyText1: TextStyle(color: dark ? Colors.white : Colors.black),
          // Adjust other text styles as needed
        ),
        iconTheme: IconThemeData(color: dark ? Colors.white : Colors.black),
        // Adjust other icon colors as needed
      ),
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      home: FutureBuilder(
          future: Future.delayed(Duration(seconds: 3)),
          builder: (ctx, timer) =>
          timer.connectionState == ConnectionState.done
              ?  Home() //Screen to navigate to once the splashScreen is done.
              : Container(
            color : Colors.white,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Image(
                image: AssetImage('assets/10th cbse new.png'),
              ),
            ),
          )),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<InitializationStatus> _initGoogleMobileAds() {

    return MobileAds.instance.initialize();
  }
  InterstitialAd? _interstitialAd;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {

            },
          );
          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }
  double progress = 0.0 ;
  bool n = false ;

  sb() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool dark = prefs.getBool('dark') ?? false ;
    n = dark ;
  }

  void initState(){
    sb();
    _initGoogleMobileAds() ;
    setState(() {

    });
    startTimer();
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? _lastPressedAt ;
  BannerAd? _bannerAd ;
  int c = 0 ;

  void startTimer() {
    // Create a periodic timer that runs the specified function every 30 seconds
    Timer.periodic(Duration(seconds: 300), (Timer timer) {
      // Call your function here
      print("Executing function every 30 seconds...");
      _loadInterstitialAd();
      _interstitialAd?.show();
      // Uncomment the next line to cancel the timer after a certain condition
      // if (someCondition) timer.cancel();
    });
  }

  Widget a( BuildContext context, String df, Color color1){
    return InkWell(
      onTap : (){
        Navigator.push(
            context, PageTransition(
            child: Page1(i: df,), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 400)
        ));
      },
      child: Container(
        width : MediaQuery.of(context).size.width / 2 ,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              decoration: BoxDecoration(
                color : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black26,
                  width: 0.5,
                ),
              ),
              child : Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                    children : [
                      Container(
                          decoration: BoxDecoration(
                            color : color1,
                            shape: BoxShape.circle,
                          ),
                          child : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(df[0], style : TextStyle(fontSize: 18, fontWeight : FontWeight.w800, color : n ? Colors.black : Colors.white)),
                          )
                      ),
                      Container(
                          child: Text(" " + df, style : TextStyle(color : Colors.black ) ))
                    ]
                ),
              )
          ),
        ),
      ),
    );
  }

  Widget z(BuildContext context, String a1, Color b1, String a2, Color b2){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        a(context, a1, b1),
        a(context, a2, b2),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Home" ),
      ),
      drawer : Df.buildDrawer(context, n),
      body: SingleChildScrollView(
        child: Column(
          children : [
            z(context, "Ncert Books 2024-25 ", Colors.green, "Ncert Solutions", Colors.red),
            z(context, "CBSE Syllabus ", Colors.blue, "Ncert Notes", Colors.purpleAccent),
            z(context, "Revision Notes", Colors.purple, "Mind Maps", Colors.yellowAccent),
            z(context, "Sample Paper", Colors.orangeAccent, "Question Banks", Colors.deepPurple),
            z(context, "PYQs", Colors.green, "Important Formulae", Colors.red),
            z(context, "RD Sharma Solution", Colors.blue, "RS Aggarwal Solution", Colors.purple),
            z(context, "KC Sinha Solution", Colors.yellow, "S.Chand Solution", Colors.purpleAccent),
            z(context, "Evergreen Solution", Colors.brown, "Xamidea Solution", Colors.lightBlue),
        
            z(context, "All in One Solution", Colors.green, "Together with Sol.", Colors.red),
            z(context, "NCERT Examp. Books", Colors.yellowAccent, "NCERT Examp. Sol.", Colors.purpleAccent),
            z(context, "Value Based Ques.", Colors.pink, "HOTs Question", Colors.deepOrange),
            z(context, "Mark Wise Ques.", Colors.orangeAccent, "Topper Ans. Sheets", Colors.red),
            z(context, "Chapter wise Test", Colors.redAccent, "MCQs Test PDF", Colors.blue),
            z(context, "Case Study PDF", Colors.green, "Assertion & Reason", Colors.red),
        
            z(context, "Lab Manual", Colors.yellowAccent, "Vocational Books", Colors.red),
            z(context, "CBSE Books", Colors.green, "KVS CBSE Worksheet", Colors.pink),
        
          ]
        ),
      ),
      /*StreamBuilder(
        stream: FirebaseFirestore.instance.collection('all').snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data?.map((e) => SessionModel.fromJson(e.data())).toList() ?? [];
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Set the number of items in each row
                  mainAxisSpacing: 10,
                ),
                itemCount: list.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChatUser(
                    user: list[index],
                  );
                },
              );

          }
        },
      ),*/

    );
  }




}
