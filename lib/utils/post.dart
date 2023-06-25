import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectify/provider/post_provider.dart';
import 'package:connectify/services/colors.dart';
import 'package:connectify/utils/comment_textfield.dart';
import 'package:connectify/utils/comments_box.dart';
import 'package:connectify/utils/like_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Post extends StatefulWidget {
  const Post(
      {super.key,
      required this.post,
      required this.postBy,
      required this.time,
      required this.userImage,
      required this.postId,
      required this.likes,
      required this.authorEmail});

  final String userImage;
  final String post;
  final String time;
  final String postBy;
  final String postId;
  final List<String> likes;
  final String authorEmail;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final commentController = TextEditingController();
  bool isliked = false;
  bool showComments = false;

  @override
  void initState() {
    super.initState();
    isliked = widget.likes.contains(currentUser.email);
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  //! LIKE POST
  void likePost() {
    setState(() {
      isliked = !isliked;
    });
    Provider.of<PostProvider>(context, listen: false)
        .likePost(isliked, widget.postId);
  }

  //! ADD COMMENT
  void addComment() {
    Provider.of<PostProvider>(context, listen: false)
        .addComment(widget.postId, commentController.text.trim());
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final post = Provider.of<PostProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black.withOpacity(0.1)),
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: darkDesign,
                          backgroundImage: NetworkImage(
                            widget.userImage,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.postBy,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            Text(
                              widget.time,
                              style: const TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ],
                    ),
                    //! DELETE COMMENTS
                    if (widget.authorEmail == currentUser.email)
                      GestureDetector(
                          onTap: () {
                            post.deletePost(context, widget.postId);
                          },
                          child: const Icon(Icons.delete))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    widget.post,
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.black.withOpacity(0.7)),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //! LIKE
                    Column(
                      children: [
                        LikeButton(isLiked: isliked, onTap: likePost),
                        Text(widget.likes.length.toString())
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),

                    //! COMMENT Buttons
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showComments = !showComments;
                            });
                          },
                          child: Icon(
                            CupertinoIcons.chat_bubble_text_fill,
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: post.commentsStream(widget.postId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                  snapshot.data!.docs.length.toString());
                            }
                            return const Text('0');
                          },
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),

                // todo: Comments list

                Visibility(
                  visible: showComments,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: post.commentsStream(widget.postId),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: darkDesign,
                          ),
                        );
                      }

                      return Column(
                        children: [
                          ListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: snapshot.data!.docs.map((doc) {
                                final commentData =
                                    doc.data() as Map<String, dynamic>;
                                DateTime timestamp =
                                    commentData['CommentTime'].toDate();
                                String formattedTime =
                                    DateFormat('h:mm a  dd/MM/yyyy')
                                        .format(timestamp);
                                return CommentsBox(
                                  commentAuthor: commentData['CommentBy'],
                                  commentText: commentData['CommentText'],
                                  commentTime: formattedTime,
                                );
                              }).toList()),
                          const SizedBox(
                            height: 5,
                          ),
                          CommentTextfield(
                              controller: commentController,
                              onTap: addComment,
                              hintText: 'Add Comment')
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
