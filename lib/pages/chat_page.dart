import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectify/services/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../provider/chat_provider.dart';
import '../utils/chat_bubble.dart';
import '../utils/my_textfield.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key,
      required this.receiverName,
      required this.receiverUserEmail,
      required this.receiverUserId});
  final String receiverName;
  final String receiverUserEmail;
  final String receiverUserId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final _messageController = TextEditingController();

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    if (_messageController.text.trim().isNotEmpty) {
      await Provider.of<ChatProvider>(context, listen: false)
          .sendMessage(widget.receiverUserId, _messageController.text.trim());

      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.receiverName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: getMessageList(),
            ),
            _buildMessageInput()
          ],
        ),
      ),
    );
  }

//getting messages

  Widget getMessageList() {
    return StreamBuilder(
      stream: Provider.of<ChatProvider>(context)
          .getMessages(widget.receiverUserId, firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading..');
        }
        return ListView(
          children: snapshot.data!.docs
              .map((document) => buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  // message Item
  Widget buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    //align current user message to right otherwise align left
    var alignment = (data['senderId'] == firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    DateTime timestamp =
        data['timestamp'].toDate(); // Convert Firestore timestamp to DateTime
    String formattedTime = DateFormat('h:mm a').format(timestamp);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: alignment,
        child: Column(
          children: [
            ChatBubble(
              message: data['message'],
              timestamp: formattedTime,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
            child: MyTextfield(
                controller: _messageController,
                hintText: 'Enter Message',
                obscureText: false)),
        IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_upward,
              size: 40,
            ))
      ],
    );
  }
}
