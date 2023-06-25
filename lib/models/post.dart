import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final datePosted;
  final String postUrl;
  final String profImage;
  final likes;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePosted,
    required this.postUrl,
    required this.profImage,
    required this.likes,
  });

  //tojson
  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "username": username,
        "postId": postId,
        "datePosted": datePosted,
        "postUrl": postUrl,
        "likes": likes,
        "profImage": profImage,
      };

  //static postfromsnap function
  static Post postFromSnap(DocumentSnapshot snap) {
    final snapShot = snap.data() as Map<String, dynamic>;
    return Post(
      description: snapShot["description"],
      uid: snapShot["uid"],
      username: snapShot["username"],
      postId: snapShot["postId"],
      datePosted: snapShot["datePosted"],
      postUrl: snapShot["postUrl"],
      profImage: snapShot["profImage"],
      likes: snapShot["likes"],
    );
  }
}
