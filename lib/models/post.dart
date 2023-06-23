import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final String datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes
  });

  Map<String, dynamic> toJson() => {
    "description": description,
    "uid": uid,
    "username": username,
    "postId": postId,
    "datePublisher": datePublished,
    "profImage": profImage,
    "postUrl": postUrl,
    "likes": likes,
  };

  static Post fromSnap(DocumentSnapshot snapshot) {
    Map<String, dynamic> snap = snapshot.data() as Map<String, dynamic>;

    return Post(
        description: snap["description"],
        uid: snap["uid"],
        username: snap["username"],
        postId: snap["postId"],
        datePublished: snap["datePublished"],
        postUrl: snap["postUrl"],
        profImage: snap["profImage"],
        likes: snap["likes"]
    );
  }

}