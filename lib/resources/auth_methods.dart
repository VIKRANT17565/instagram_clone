import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/resources/storage_method.dart';
import 'package:instagram_clone/models/user.dart' as userModel;

// import 'package:flutter/material.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // get current user
  Future<userModel.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    // DocumentSnapshot documentSnapshot =
    //     await _fireStore.collection('users').doc(currentUser.uid).get();

    DocumentSnapshot documentSnapshot =
        await _fireStore.collection('users').doc(currentUser.uid).get();

    return userModel.User.userFromSnap(documentSnapshot);
  }

  //sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List profilePic,
  }) async {
    String result = 'Some Error Occured';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          // ignore: unnecessary_null_comparison
          profilePic != null) {
        //register user
        final UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        print(userCredential.user!.uid);

        String photoUrl = await StorageMethod().uploadImageToStorage(
          childName: 'profile_pic',
          file: profilePic,
          isPost: false,
        );

        userModel.User user = userModel.User(
          uid: userCredential.user!.uid,
          email: email,
          username: username,
          bio: bio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        );

        // add user details to firestore
        await _fireStore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toJSon());

        result = 'success';
      }
    } catch (e) {
      result = e.toString();
    }
    return result;
  }

  // login user with email and password
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String result = 'Some Error Occured';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        //register user
        // final UserCredential userCredential =
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // print(userCredential.user!.uid);

        result = 'success';
      } else {
        result = 'Please enter email and password';
      }
    } catch (e) {
      result = e.toString();
    }
    return result;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
