import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/services/StorageService.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  final FirebaseFirestore _firebaseFirestore  = FirebaseFirestore.instance;

  // method for uploading post
  Future<String> uploadPost(
      String description,
      Uint8List file,
      String uid,
      String username,
      String profImage
    ) async {
    String res = "Some error occured";
    try {
      String photoUrl = await StorageService().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          postId: postId,
          datePublished: DateTime.now().toString(),
          postUrl: photoUrl,
          profImage: profImage,
          likes: []
      );

      await _firebaseFirestore.collection('posts').doc(postId).set(post.toJson());

      res = "Success";
    } catch(e) {
      res = e.toString();
    }

    return res;
  }

  // method to like a post
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if(likes.contains(uid)) {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch(e) {
      print(e.toString());
    }
  }


  // method to comment in a post
  Future<void> postComment(String postId, String comment, String uid, String name, String profPic) async {
    try {
      if(comment.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firebaseFirestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profPic': profPic,
          'name': name,
          'uid': uid,
          'comment': comment,
          'datePublished': DateTime.now()
        });
      }
    } catch(e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firebaseFirestore.collection('posts').doc(postId).delete();
    } catch(e) {
      print(e.toString());
    }
  }

  Future<void> followUser(
    String uid,
    String followId
  ) async {
    var snap = await _firebaseFirestore.collection('users').doc(uid).get();
    List following = snap.data()!['following'];
    if (following.contains(followId)) {
      await _firebaseFirestore.collection('users').doc(uid).update({
        'following': FieldValue.arrayRemove([followId])
      });

      await _firebaseFirestore.collection('users').doc(followId).update({
        'followers': FieldValue.arrayRemove([uid])
      });
    } else {
      await _firebaseFirestore.collection('users').doc(uid).update({
        'following': FieldValue.arrayUnion([followId])
      });
      await _firebaseFirestore.collection('users').doc(followId).update({
        'followers': FieldValue.arrayUnion([uid])
      });
    }
  }
}