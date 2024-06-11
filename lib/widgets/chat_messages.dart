import 'package:chat_app_course/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something Went Wrong'),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No new Message Yet'),
          );
        }
        final doc = snapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
          reverse: true,
          itemCount: doc.length,
          itemBuilder: (context, index) {
            final chatMessage = doc[index].data();
            final nextChatMessage =
                index + 1 < doc.length ? doc[index + 1].data() : null;
            final currentUserId = chatMessage['userId'];
            final nextUserId =
                nextChatMessage != null ? nextChatMessage['userId'] : null;
            final sameUser = currentUserId == nextUserId;
            if (sameUser) {
              return MessageBubble.next(
                  message: chatMessage['text'],
                  isMe: authenticatedUser == currentUserId);
            } else {
              return MessageBubble.first(
                  userImage: chatMessage['userImage'],
                  username: chatMessage['username'],
                  message: chatMessage['text'],
                  isMe: authenticatedUser.uid == currentUserId);
            }
          },
        );
      },
    );
  }
}
