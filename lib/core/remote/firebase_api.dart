import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/features/noti/noti_screen.dart';

class FirebaseApi
{
  final _firebaseMessaging = FirebaseMessaging.instance;

  void handleMessage(RemoteMessage? remoteMessage,context){
    if(remoteMessage == null) return;
    Navigator.push(context,MaterialPageRoute(builder: (context)=>const NotificationScreen()));
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  Future<void> initNotifications() async
  {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}


Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}