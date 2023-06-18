
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/services/StorageService.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    
    DocumentSnapshot snap = await _firestore.collection("users").doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  //sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        String photoUrl = await StorageService().uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
            email: email,
            uid: credential.user!.uid,
            photoUrl: photoUrl,
            username: username,
            bio: bio,
            follower: [],
            following: []
        );

        // add user to db
        await _firestore.collection('users').doc(credential.user!.uid).set(user.toJson());
        res = "success";
      }
    } on FirebaseAuthException catch(e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password
}) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
       await _auth.signInWithEmailAndPassword(email: email, password: password);
       res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } on FirebaseAuthException catch(e) {
      if (e.code == "user-not-found") {
        res = "This email is not registered";
      } else if (e.code == "wrong-password") {
        res = "Wrong password";
      }
    }
    catch(e) {
      res = e.toString();
    }

    return res;
  }
}