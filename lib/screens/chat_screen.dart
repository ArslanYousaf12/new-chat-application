import 'package:chat_app_course/widgets/chat_messages.dart';
import 'package:chat_app_course/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setup() async {
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    // final token = await messaging.getToken();
    // print(token);
    messaging.subscribeToTopic('chat');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat Screen'),
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: Icon(
                  Icons.exit_to_app,
                  color: Theme.of(context).colorScheme.primary,
                ))
          ],
        ),
        body: Column(
          children: [
            Expanded(child: const ChatMessages()),
            NewMessage(),
          ],
        ));
  }
}
