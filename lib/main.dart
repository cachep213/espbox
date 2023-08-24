
import 'package:boxapp/firebase_options.dart';
import 'package:boxapp/services/firebase_helper.dart';
import 'package:boxapp/services/notification.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

late final Widget screen;
// late final tokenuser;
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseHelper.setupFirebase();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  screen = FirebaseHelper.homeScreen;
  await NotificationService.initializeNotification();
  
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESPBOX',
      navigatorKey: MyApp.navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.black,
      ),
      home: screen,
    );
  }
}