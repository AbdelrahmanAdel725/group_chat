import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/core/strings.dart';
import 'package:group_chat_app/features/auth/login_ui.dart';
import 'package:group_chat_app/shared/widgets/message.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User signedInUser;
  String? deviceKey = '';
  final auth = FirebaseAuth.instance;


  getDeviceKey() async {
    try{
      deviceKey = await FirebaseMessaging.instance.getToken();
    }catch(e){
      print('could not get the key');
    }
    if(deviceKey!.isNotEmpty)
    {
      print(deviceKey);
    }
  }

  @override
  void initState() {
    getDeviceKey();
    getCurrentUser();
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }



  void getCurrentUser() {
    try {
      final user = auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void messagesStream() async {
    await for (var snapshot
        in FirebaseFirestore.instance.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  TextEditingController messageController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Messages'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: StreamBuilder<ConnectivityResult>(
              stream: Connectivity().onConnectivityChanged,
              builder: (context, snapshot) {
                return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('messages')
                                .orderBy('date', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              List<MessageWidget> messageWidgets = [];
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              final messages = snapshot.data!.docs;

                              for (var message in messages) {
                                final messageText = message.get('text');
                                final messageSender = message.get('senderId');
                                final currentUser = signedInUser.email;
                                final messageWidget = MessageWidget(
                                  text: messageText,
                                  sender: messageSender,
                                  isMe: currentUser == messageSender,
                                );
                                messageWidgets.add(messageWidget);
                                print(messageText);
                              }
                              return Expanded(
                                child: ListView(
                                  reverse: true,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 20),
                                  children: messageWidgets,
                                ),
                              );
                            },
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  height: 60,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey[300],
                                  ),
                                  child: Center(
                                    child: TextFormField(
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      controller: messageController,
                                      decoration: const InputDecoration(
                                        hintText: 'Write your message here...',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Container(
                                width: 55,
                                height: 55,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    try {
                                      if (messageController.text.isNotEmpty) {
                                        String text = messageController.text;
                                        messageController.clear();
                                        await FirebaseFirestore.instance
                                            .collection('messages')
                                            .add({
                                          'text': text,
                                          'senderId': Stringat.userId,
                                          'date': DateTime.now(),
                                        }).then((value) {
                                          messageController.clear();
                                          print('Success');
                                        });

                                      }
                                    } catch (e) {
                                      print('tsssssssßs1s1ßß');
                                    }
                                  },
                                  child: const Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
              }),
        ),
      ),
    );
  }
}
