import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/app.dart';
import 'package:group_chat_app/core/remote/firebase_api.dart';
import 'package:group_chat_app/core/strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stringat.token = (await FirebaseMessaging.instance.getToken());
  runApp(const MyApp());
}


