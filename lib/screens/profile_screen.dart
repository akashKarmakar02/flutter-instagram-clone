import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/follow_button.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/services/FirestoreService.dart';

class ProfileScreen extends StatefulWidget {
  final String? uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Map<String, dynamic>? userData;
  int? postLength;
  bool isFollowing = false;
  bool isLoading = false;
  int followers = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      DocumentSnapshot userSnap = await _firestore.collection('users').doc(widget.uid).get();
      var postSnap = await _firestore.collection('posts').where('uid', isEqualTo: widget.uid).get();
      setState(() {
        userData = userSnap.data() as Map<String, dynamic>;
        postLength = postSnap.docs.length;
        isFollowing = userData?['followers'].contains(FirebaseAuth.instance.currentUser!.uid);
        followers = userData!['followers'].length;
        isLoading = false;
      });
    } catch(e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser!;

    return isLoading ? const Center(
      child: CupertinoActivityIndicator(),
    ): Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(userData?['username']),
        centerTitle: false,
      ),
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                          userData!['photoUrl'],
                      ),
                      radius: 40,
                    ),
                    
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildStateColumn(postLength!, "posts"),
                          buildStateColumn(followers, "followers"),
                          buildStateColumn(userData!["following"].length, "following"),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    userData?['username'] ?? "username",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 1),
                  child: Text(
                    userData?['bio'] ?? "Some description"
                  ),
                ),
                FirebaseAuth.instance.currentUser?.uid == widget.uid ? FollowButton(
                  backgroundColor: Colors.grey[850]!,
                  text: "Edit Profile",
                  borderColor: Colors.grey[850]!,
                  textColor: primaryColor,
                  function: () {},
                ) : isFollowing ? FollowButton(
                  backgroundColor: Colors.grey[850]!,
                  text: "Unfollow",
                  borderColor: Colors.grey[850]!,
                  textColor: primaryColor,
                  function: () async {
                    await FirestoreService().followUser(FirebaseAuth.instance.currentUser!.uid, userData!['uid']);
                    setState(() {
                      isFollowing = false;
                      followers--;
                    });
                  },
                ) : FollowButton(
                  backgroundColor: Colors.blue,
                  text: "Follow",
                  borderColor: Colors.blue,
                  textColor: Colors.white,
                  function: () async {
                    await FirestoreService().followUser(user.uid, userData!['uid']);
                    setState(() {
                      isFollowing = true;
                      followers++;
                    });
                  },
                )
              ],
            ),
          ),
          Divider(
            color: Colors.grey[700]!,
          ),
          FutureBuilder(
            future: _firestore.collection('posts').where('uid', isEqualTo: widget.uid).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CupertinoActivityIndicator()
                );
              }
              return GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 1.5,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  DocumentSnapshot snap = snapshot.data!.docs[index];
                  return Image(
                    image: NetworkImage(
                      snap['postUrl']
                    ),
                    fit: BoxFit.cover,
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
  
  Column buildStateColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        )
      ],
    );
  }
}
