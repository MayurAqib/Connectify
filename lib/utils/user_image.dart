import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectify/provider/profile_provider.dart';
import 'package:connectify/services/colors.dart';
import 'package:connectify/utils/upload_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserImage extends StatefulWidget {
  const UserImage({super.key, required this.onPickImage, required this.onSave});
  final void Function(File pickedImage) onPickImage;
  final void Function()? onSave;

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  File? pickedImageFile;

  void fromGallery() async {
    Provider.of<ProfileProvider>(context, listen: false)
        .fromGallery(widget.onPickImage);
  }

  void fromCamera() async {
    Provider.of<ProfileProvider>(context, listen: false)
        .fromCamera(widget.onPickImage);
  }

  void onCancel() {
    setState(() {
      pickedImageFile == null;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Stack(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(currentUser.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final profileData =
                    snapshot.data!.data() as Map<String, dynamic>;

                if (profileData['UserImage'] ==
                    'https://cdn-icons-png.flaticon.com/128/149/149071.png') {
                  return const CircleAvatar(
                    radius: 70,
                    backgroundColor: darkDesign,
                    backgroundImage: NetworkImage(
                        'https://cdn-icons-png.flaticon.com/128/149/149071.png'),
                  );
                } else {
                  return CircleAvatar(
                    radius: 70,
                    backgroundColor: darkDesign,
                    backgroundImage: NetworkImage(profileData['UserImage']),
                  );
                }
              }
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircleAvatar(
                  radius: 70,
                  backgroundColor: darkDesign,
                  child: Center(child: Text('Uploading..')),
                );
              }

              return const CircleAvatar(
                radius: 70,
                backgroundColor: darkDesign,
                backgroundImage: NetworkImage(
                    'https://cdn-icons-png.flaticon.com/128/149/149071.png'),
              );
            },
          ),
          Opacity(
              opacity: 0,
              child: pickedImageFile != null
                  ? CircleAvatar(
                      radius: 70,
                      backgroundColor: darkDesign,
                      child: Image.file(pickedImageFile!))
                  : const CircleAvatar(
                      backgroundColor: Colors.amber,
                    )),
          Positioned(
            bottom: 10,
            right: 25,
            child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return UploadDialog(
                          camera: fromCamera,
                          gallery: fromGallery,
                          onCancel: onCancel,
                          onSave: widget.onSave!);
                    },
                  );
                },
                child: const Icon(
                  Icons.edit,
                  color: Colors.black,
                )),
          )
        ],
      ),
    );
  }
}
