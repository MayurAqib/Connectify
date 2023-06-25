import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectify/pages/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatelessWidget {
  const ChatRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            Expanded(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('Users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('loading..');
                  }
                  if (snapshot.hasData) {
                    return ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: snapshot.data!.docs
                          .map<Widget>((doc) => _userListItem(doc, context))
                          .toList(),
                    );
                  }
                  return const Text('Error occured');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userListItem(DocumentSnapshot document, BuildContext context) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    final currentUser = FirebaseAuth.instance.currentUser!;
    if (currentUser.email != data['Email']) {
      return Container(
        margin: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.withOpacity(0.3))),
        child: ListTile(
          contentPadding: const EdgeInsets.all(5),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                        receiverName: data['Name'],
                        receiverUserEmail: data['Email'],
                        receiverUserId: data['uid'])));
          },
          // leading: ProfilePicture(
          //   radius: 30,
          // ),
          title: Text(
            data['Name'],
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    return Container();
  }
}
