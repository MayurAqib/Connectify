import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // todo:  CREATE ACCOUNT
  Future<void> signUp(
      BuildContext context,
      String firstName,
      String lastName,
      String email,
      String password,
      String confirmPassword,
      String mobileNumber) async {
    if (context.mounted) {
      FocusScope.of(context).unfocus();
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('passwords do not match')));
      return;
    }
    if (mobileNumber.isEmpty || mobileNumber.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enter a valid mobile number')));
      return;
    }
    if (firstName.length < 3 || firstName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('First Name should be at least 3 characters long')));
      return;
    }
    if (lastName.length < 3 || lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Last Name should be at least 3 characters long')));
      return;
    }
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await firestore.collection('Users').doc(userCredential.user!.email).set({
        'Name': '$firstName $lastName',
        'UserName': '${firstName}_$lastName',
        'Mobile Number': mobileNumber,
        'Email': userCredential.user!.email,
        'uid': userCredential.user!.uid,
        'Gender': '',
        'Age': '',
        'UserImage': 'https://cdn-icons-png.flaticon.com/128/149/149071.png'
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }

  // todo:  LOGIN ACCOUNT
  Future<void> signIn(
      String email, String password, BuildContext context) async {
    if (context.mounted) {
      FocusScope.of(context).unfocus();
    }
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }

  // todo:  LOGOUT ACCOUNT
  Future<void> signOut() async {
    return await firebaseAuth.signOut();
  }

  //todo: reset password
  Future<void> resetPassword(BuildContext context, String email) async {
    if (email.isEmpty) {
      return;
    }
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }
}
