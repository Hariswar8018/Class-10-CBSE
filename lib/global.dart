import 'package:class11/first/login.dart';
import 'package:class11/main/all_pdf.dart';
import 'package:class11/main/all_pdfs.dart';
import 'package:class11/second/articles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'dart:ui';
import 'main.dart';

class Df {

  static Future<void> onStateChanged(bool ihs) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool dark = prefs.getBool('dark') ?? false ;
    if(dark){
      prefs.setBool("dark", false) ;
    }else{
      prefs.setBool("dark", true) ;
    }
    Restart.restartApp();
  }

  static String s = FirebaseAuth.instance.currentUser?.uid ?? "a" ;

  static Widget a( String gh,  Widget ic ) {
    return ListTile(
      leading: ic,
      title: Text(gh),
      trailing: const Icon(
        Icons.arrow_forward_ios_sharp,
        color: Colors.blue,
        size: 20,
      ),
      splashColor: Colors.orange.shade100,
    );
  }

  static Widget buildDrawer(BuildContext context, bool isDarkModeEnabled) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
              color: Colors.blue,
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/10th cbse new.png",
                      height: 100,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(" Class 10 CBSE",
                        style: TextStyle(color: Colors.white, fontSize: 22))
                  ],
                ),
              )),
          s == "a"
              ? InkWell(
                  onTap: () async {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: LoginScreen(),
                            type: PageTransitionType.rightToLeft,
                            duration: const Duration(milliseconds: 800)));
                  },
                  child: as(
                      const Icon(
                        Icons.login_outlined,
                        color: Colors.blue,
                        size: 30,
                      ),
                      "Login Now"))
              : InkWell(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                    Restart.restartApp();
                  },
                  child: as(
                      const Icon(
                        Icons.logout_outlined,
                        color: Colors.red,
                        size: 30,
                      ),
                      "Log Out")),
          ListTile(
            leading: const Icon(
              Icons.dark_mode_rounded,
              color: Colors.blue,
              size: 30,
            ),
            title: const Text("Dark Mode"),
            splashColor: Colors.orange.shade200,
            trailing: DayNightSwitcherIcon(
              isDarkModeEnabled: isDarkModeEnabled,
              onStateChanged: onStateChanged,
            ),
          ),
          InkWell(
              onTap: () async {
                PermissionStatus status = await Permission.storage.status;

                // If permission is granted
                if (status.isGranted) {
                  // Permission is already granted, proceed with your logic here
                  Navigator.push(
                      context,
                      PageTransition(
                          child: const DownloadedPDF(),
                          type: PageTransitionType.rightToLeft,
                          duration: const Duration(milliseconds: 800)));
                  print('Storage permission is granted.');
                  // You can navigate to another screen or perform any action here
                } else {
                  // If permission is not granted, request it
                  PermissionStatus permissionStatus =
                      await Permission.storage.request();
                  // If user grants the permission
                  if (permissionStatus.isGranted) {
                    // Permission granted, proceed with your logic here
                    print('Storage permission is granted.');
                    Navigator.push(
                        context,
                        PageTransition(
                            child: const DownloadedPDF(),
                            type: PageTransitionType.rightToLeft,
                            duration: const Duration(milliseconds: 800)));
                    // You can navigate to another screen or perform any action here
                  } else {
                    // Permission not granted, show a message to the user or handle accordingly
                    print('Storage permission is not granted.');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Storage Permission not Granted"),
                      ),
                    );
                  }
                }


              },
              child: a(
                  "Download Books", const Icon(Icons.picture_as_pdf, color: Colors.blue))),
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: DownloadedPDFList(),
                        type: PageTransitionType.rightToLeft,
                        duration: const Duration(milliseconds: 800)));
              },
              child: a(
                  "Bookmark Books", const Icon(Icons.download, color: Colors.blue))),
          InkWell(
              onTap: () {
                if (s == "a") {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Login to use this Feature'),
                    duration: const Duration(seconds: 5),
                    action: SnackBarAction(
                      label: 'Login Now',
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: LoginScreen(),
                                type: PageTransitionType.rightToLeft,
                                duration: const Duration(milliseconds: 800)));
                      },
                    ),
                  ));
                } else {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Blog2(
                            what: 'activity',
                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: const Duration(milliseconds: 800)));
                }
              },
              child: a("Activity",
                  const Icon(Icons.access_time_filled, color: Colors.blue))),
          InkWell(
              onTap: () {
                if (s == "a") {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Login to use this Feature'),
                    duration: const Duration(seconds: 5),
                    action: SnackBarAction(
                      label: 'Login Now',
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: LoginScreen(),
                                type: PageTransitionType.rightToLeft,
                                duration: const Duration(milliseconds: 800)));
                      },
                    ),
                  ));
                } else {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Blog2(
                            what: 'bookmark',
                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: const Duration(milliseconds: 800)));
                }
              },
              child:
                  a("Article Bookmarks", const Icon(Icons.book, color: Colors.blue))),
          InkWell(
              onTap: () async {
                final Uri _url = Uri.parse(
                    'https://play.google.com/store/apps/details?id=com.heavenonthisearth.class11');
                if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                }
              },
              child: a("Rate us", const Icon(Icons.star_rate, color: Colors.blue))),
          InkWell(
              onTap: () async {
                final Uri _url =
                    Uri.parse('https://xambites.com/index.php/privacy-policy-2/');
                if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                }
              },
              child: a("Privacy Policy",
                  const Icon(Icons.privacy_tip, color: Colors.blue))),
          InkWell(
              onTap: () async {
                final Uri _url = Uri.parse(
                    'https://play.google.com/store/apps/dev?id=7885407931161174976');
                if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                }
              },
              child: a("Our Apps", const Icon(Icons.share, color: Colors.blue))),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  static Widget as(Widget s, String s1) {
    return ListTile(
      leading: s,
      title: Text(s1),
      splashColor: Colors.orange.shade200,
      trailing: const Icon(
        Icons.arrow_forward_ios_sharp,
        color: Colors.blue,
        size: 20,
      ),
    );
  }
}
