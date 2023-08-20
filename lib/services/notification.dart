

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:boxapp/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static get context => null;

  static Future<void> displayNotificationRationale() async {
    return  showDialog <void>(
        context:  MyApp.navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Get Notified!',
                style: Theme.of(context).textTheme.titleLarge),
            content:  const SingleChildScrollView(
              child: ListBody(
              children: <Widget>[
                // Row(
                //   children: [
                //     // Expanded(
                //       // child: Image.asset(
                //       //   'assets/animated-bell.gif',
                //       //   height: MediaQuery.of(context).size.height * 0.3,
                //       //   fit: BoxFit.fitWidth,
                //       // ),
                //     // ),
                //   ],
                // ),
                 SizedBox(height: 20),
                 Text('Allow Notifications to send you SafeHave Packages notifications!'),
              ],
            ),
            ),
            actions: <Widget> [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Deny',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.red),
                  )
                  ),
              TextButton(
                  onPressed: () async {
                   await AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context));
                  },
                  child: Text(
                    'Allow',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.deepPurple),
                  ),
               ),
            ],
          );
        },
      );
  }

  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/res_notification_app_icon',
      [
        NotificationChannel(
          channelGroupKey: 'high_importance_channel',
          channelKey: 'high_importance_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'high_importance_channel_group',
          channelGroupName: 'Group 1',
        )
      ],
      debug: true,
    );
  }


  static Future<void> showNotification({
    required final String title,
    required final String body,
  }) async {
     bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
     if (!isAllowed) {
       displayNotificationRationale();
    }
    if (!isAllowed) return;
    await AwesomeNotifications().createNotification(
      
      content: NotificationContent(
        id: -1,
        channelKey: 'high_importance_channel',
        title: title,
        body: body,
      ),
    );
  }
 
  static Future<String> requestFirebaseToken() async {
    String token = (await FirebaseMessaging.instance.getToken())!;
    debugPrint('==================FCM Token==================');
    debugPrint(token);
    debugPrint('======================================');
    return token;
  }
}