import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectify/provider/profile_provider.dart';
import 'package:connectify/services/colors.dart';
import 'package:connectify/utils/profile_details_list.dart';
import 'package:connectify/utils/user_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final detailController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    final profilePro = Provider.of<ProfileProvider>(context);
    return SingleChildScrollView(
        child: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: $Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text('Loading...'),
          );
        }

        final profile = snapshot.data!.data() as Map<String, dynamic>;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                const SizedBox(
                  height: 320,
                ),
                Container(
                  height: 260,
                  decoration: BoxDecoration(
                      color: backgroundColor,
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://images.unsplash.com/photo-1682686581498-5e85c7228119?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwyNnx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60'),
                          fit: BoxFit.cover)),
                ),
                Positioned(
                    bottom: 0,
                    left: 30,
                    child: UserImage(
                      onPickImage: (pickedImage) =>
                          _selectedImage = pickedImage,
                      onSave: () {
                        profilePro.imageUpload(_selectedImage!);
                        Navigator.of(context).pop();
                      },
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 55, top: 20, bottom: 20),
              child: Text(
                profile['Name'],
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  ProfileDetails(
                    section: 'Email',
                    sectionText: profile['Email'],
                  ),
                  ProfileDetails(
                    section: 'Name',
                    sectionText: profile['Name'],
                    icon: Icons.edit,
                    onpressed: () => profilePro.editDetails(context, 'Name'),
                  ),
                  ProfileDetails(
                    section: 'Age',
                    sectionText: profile['Age'],
                    icon: Icons.edit,
                    onpressed: () => profilePro.editDetails(context, 'Age'),
                  ),
                  ProfileDetails(
                    section: 'UserName',
                    sectionText: profile['UserName'],
                    icon: Icons.edit,
                    onpressed: () =>
                        profilePro.editDetails(context, 'UserName'),
                  ),
                  ProfileDetails(
                    section: 'Gender',
                    sectionText: profile['Gender'],
                    icon: Icons.edit,
                    onpressed: () => profilePro.editDetails(context, 'Gender'),
                  ),
                  ProfileDetails(
                    section: 'Mobile Number',
                    sectionText: profile['Mobile Number'],
                    icon: Icons.edit,
                    onpressed: () =>
                        profilePro.editDetails(context, 'Mobile Number'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)),
                        child: const Text('Logout')),
                  )
                ],
              ),
            )
          ],
        );
      },
    ));
  }
}
