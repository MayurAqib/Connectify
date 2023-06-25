import 'package:connectify/provider/post_provider.dart';
import 'package:connectify/services/colors.dart';
import 'package:connectify/utils/my_button.dart';
import 'package:connectify/utils/my_textfield.dart';
import 'package:connectify/utils/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final postController = TextEditingController();
  //todo: Posting
  void posting() async {
    Provider.of<PostProvider>(context, listen: false)
        .post(context, postController.text.trim());

    setState(() {
      postController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = Provider.of<PostProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: MyTextfield(
                          controller: postController,
                          hintText: 'What\'s on your mind?',
                          obscureText: false)),
                  const SizedBox(width: 10),
                  MyButton(
                    buttonText: 'Post',
                    onTap: posting,
                    width: 80,
                  )
                ],
              ),
              StreamBuilder(
                stream: post.postStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        DateTime timestamp = post['TimeStamp'].toDate();
                        String formattedTime =
                            DateFormat('h:mm a      dd/MM/yyyy')
                                .format(timestamp);

                        return Post(
                          post: post['Post'],
                          postBy: post['PostBy'],
                          time: formattedTime,
                          userImage: post['UserImage'],
                          postId: post.id,
                          likes: List<String>.from(post['Likes'] ?? []),
                          authorEmail: post['AuthorEmail'],
                        );
                      },
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: darkDesign,
                      ),
                    );
                  }
                  return const Center(child: Text('No Post Yet'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
