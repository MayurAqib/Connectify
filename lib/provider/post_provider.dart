import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectify/services/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //todo: WALL POST
  Future<void> post(BuildContext context, String postController) async {
    if (postController.isEmpty) {
      return;
    }
    final currentUser = firebaseAuth.currentUser!;
    DocumentSnapshot documentSnapshot =
        await firestore.collection('Users').doc(currentUser.email).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    await firestore.collection('UserPosts').add({
      'AuthorEmail': currentUser.email,
      'PostBy': data['Name'],
      'Post': postController,
      'TimeStamp': Timestamp.now(),
      'Likes': [],
      'UserImage': data['UserImage']
    });

    if (context.mounted) {
      FocusScope.of(context).unfocus();
    }
  }
  //todo: Streaming the post

  Stream postStream() {
    return firestore
        .collection('UserPosts')
        .orderBy('TimeStamp', descending: true)
        .snapshots();
  }

  //todo: ADD COMMENT

  Future<void> addComment(String postId, String comment) async {
    // await firestore.clearPersistence();
    final user = firebaseAuth.currentUser!;
    DocumentSnapshot documentSnapshot =
        await firestore.collection('Users').doc(user.email).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    firestore.collection('UserPosts').doc(postId).collection('Comments').add({
      'CommentBy': data['Name'],
      'CommentText': comment,
      'CommentTime': Timestamp.now()
    });
  }

  //steaming of new comment
  Stream<QuerySnapshot> commentsStream(String postId) {
    return firestore
        .collection('UserPosts')
        .doc(postId)
        .collection('Comments')
        .orderBy('CommentTime', descending: true)
        .snapshots();
  }

  //todo: LIKE POST

  void likePost(bool isliked, String postId) {
    final currentUser = firebaseAuth.currentUser!;

    DocumentReference postRef = firestore.collection('UserPosts').doc(postId);

    if (isliked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  //todo: DELETE THE POST
  Future<void> deletePost(BuildContext context, String postId) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: darkDesign,
              title: const Text(
                'Are you sure?',
                style: TextStyle(color: textColor),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: textColor),
                    )),
                TextButton(
                    onPressed: () async {
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                      //! delete comments first
                      deleteAllComments(postId);
                      //! NOW DELETE THE POST
                      await firestore
                          .collection('UserPosts')
                          .doc(postId)
                          .delete()
                          .then((value) => debugPrint('post deleted'))
                          .catchError((error) =>
                              debugPrint('failed to delete post: $error'));
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: textColor),
                    )),
              ],
            ));
  }

  //todo: delete comments
  void deleteAllComments(String postId) async {
    final commentDocs = await firestore
        .collection('UserPosts')
        .doc(postId)
        .collection('Comments')
        .get();
    // ignore: unnecessary_null_comparison
    if (commentDocs != null) {
      for (var doc in commentDocs.docs) {
        await firestore
            .collection('UserPosts')
            .doc(postId)
            .collection('Comments')
            .doc(doc.id)
            .delete();
      }
    }
  }
}
