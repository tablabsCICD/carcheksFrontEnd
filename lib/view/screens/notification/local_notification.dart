import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    // initializationSettings  for Android
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: AndroidInitializationSettings("carchecks"),
        );

    _notificationsPlugin.initialize(
      initializationSettings,
      /* onSelectNotification: (String? id) async {
        print("onSelectNotification");
        if (id!.isNotEmpty) {
          print("Router Value1234 $id");

          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => DemoScreen(
          //       id: id,
          //     ),
          //   ),
          // );


        }
      },*/
    );
  }

  static void createanddisplaynotification(RemoteMessage message) async {
    // print('the notification is ${message.notification!.body}');
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "TKDost",
          "TKDost",
          icon: '@mipmap/ic_launcher',
          largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      print('the massage data value is ${message.data}');
      print('the massage data value is ${message.data.toString()}');
      await _notificationsPlugin.show(
        id,
        message.data.values.last,
        message.data['subTitle'],
        notificationDetails,
        payload: message.data['_id'],
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}
