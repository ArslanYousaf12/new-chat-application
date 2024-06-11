import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewMessage extends StatefulWidget {
  NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _textController = TextEditingController();
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submit() async {
    final submitValue = _textController.text;
    if (submitValue.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _textController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userdata = await FirebaseFirestore.instance
        .collection('user_data')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': submitValue,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userdata.data()!['name'],
      'userImage': userdata.data()!['Image_url'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 1, bottom: 5, top: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                label: Text('send a message..'),
              ),
              enableSuggestions: true,
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            onPressed: _submit,
            icon: const Icon(Icons.send),
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
