import 'dart:io';

import 'package:boxapp/services/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../screens/home.dart';
import '../screens/sigup.dart';
import '../firebase_options.dart';

class FirebaseHelper {
  const FirebaseHelper._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;


  static Future<void> setupFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: false,
      sound: true,
    );
    // FirebaseMessaging.instance.getInitialMessage().then((value) => null)
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if(notification != null){
          NotificationService.showNotification(title: notification.title.toString(), body: notification.body.toString());
      }
    });

  }

  static Future<bool> saveUser({
    required String email,
    required String password,
  }) async {
    final UserCredential credential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user == null) {
      return false;
    }

    //start implementing firestore
    var userRef = _db.collection('user').doc(
          credential.user!.uid,
        );

    final now = DateTime.now();

    final String createdAt = '${now.year}-${now.month}-${now.day}-${now.hour}-${now.minute}';

    final String token = await NotificationService.requestFirebaseToken();
    String token1 = token.toString();

  // final String? token = await FirebaseMessaging.instance.getToken();
    if (token1 == '') return false;

    final userModel = UserModel(
      createdAt: createdAt,
      username: email,
      platform: Platform.operatingSystem,
      token: token1,
      uid: credential.user!.uid,
    );

    await userRef.set(userModel.toJson());

    return true;
  }

  static Widget get homeScreen {
    if (_auth.currentUser != null) {
      return  const HomeScreen();
    }

    return const SignUpScreen();
  }


 
}//end class


Future<void> _onBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('we have received a notification ${message.notification}');
  }