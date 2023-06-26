import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isShowUser = false;
  
  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Search for a user'
          ),
          onSubmitted: (String _) {
            setState(() {
              isShowUser = true;
            });
          },
        ),
      ),
      body: isShowUser? FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .where('username', isGreaterThanOrEqualTo: _searchController.text)
            .get(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data!.docs[index].data()['photoUrl']),
                ),
                title: Text(snapshot.data!.docs[index].data()['username']),
              );
            },
          );
        },

      ): FutureBuilder(
        future: FirebaseFirestore.instance.collection('posts').get(),
        builder: (context, snapshot) {
          if(!snapshot.hasData || snapshot.data == null || snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }

          return StaggeredGridView.countBuilder(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            crossAxisCount: 4,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Image.network(
                snapshot.data!.docs[index].get('postUrl'),
                fit: BoxFit.cover,
              );
            },
            staggeredTileBuilder: (int index) => StaggeredTile.count((index % 7 == 0)? 2:1, (index % 7 == 0)? 2:1),
          );
        },
      ),
    );
  }
}
