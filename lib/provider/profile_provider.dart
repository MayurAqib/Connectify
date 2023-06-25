import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectify/services/colors.dart';
import 'package:connectify/utils/upload_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileProvider extends ChangeNotifier {
  //!  Instances

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  // todo: Edit profile details function

  Future<void> editDetails(BuildContext context, String field) async {
    final currentUser = firebaseAuth.currentUser!;
    final editController = TextEditingController();
    String newValue = '';
    final userCollection = firestore.collection('Users');
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.black,
              title: Text('Edit: $field',
                  style: const TextStyle(color: textColor)),
              content: TextField(
                controller: editController,
                onChanged: (value) {
                  newValue = value;
                },
                decoration: InputDecoration(
                    fillColor: textColor,
                    filled: true,
                    hintText: 'Enter $field',
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8))),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: textColor),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(newValue);
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(color: textColor),
                    )),
              ],
            ));
    //! UPDATE VALUE IN FIRESTORE
    if (newValue.trim().isNotEmpty) {
      await userCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  // todo: SELECTING IMAGE
  void selectImage(BuildContext context, Function() gallery, Function() camera,
      Function() onSave, Function() onCancel) {
    showDialog(
        context: context,
        builder: (context) => UploadDialog(
            camera: camera,
            gallery: gallery,
            onCancel: onCancel,
            onSave: onSave));
  }

  //todo: open  gallery
  File? pickedImageFile;

  Future<void> fromGallery(onPickImage) async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (pickedImage == null) {
      return;
    }

    pickedImageFile = File(pickedImage.path);
    notifyListeners();
    onPickImage(pickedImageFile!);
  }

  //todo: open  camera
  Future<void> fromCamera(onPickImage) async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 100);

    if (pickedImage == null) {
      return;
    }

    pickedImageFile = File(pickedImage.path);
    notifyListeners();
    onPickImage(pickedImageFile!);
  }

  // ! finally update image in firebase
  final userCollection = FirebaseFirestore.instance.collection('Users');

  Future<void> imageUpload(selectedImage) async {
    final user = FirebaseAuth.instance.currentUser!;
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('imageUrl')
        .child('$timestamp/${user.uid}.jpg');

    final uploadTask = storageRef.putFile(selectedImage);
    await uploadTask.whenComplete(() {});
    final imageUrl = await storageRef.getDownloadURL();

    if (uploadTask.snapshot.state == TaskState.success) {
      await userCollection
          .doc(currentUser.email)
          .update({'UserImage': imageUrl});
    }
    final userPostCollection = FirebaseFirestore.instance
        .collection('UserPosts')
        .doc(currentUser.email);

    final userPostDoc = await userPostCollection.get();

    if (userPostDoc.exists) {
      await userPostCollection.update({'UserImage': imageUrl});
    }
  }
}
