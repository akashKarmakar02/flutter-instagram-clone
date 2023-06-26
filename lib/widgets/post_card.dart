import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/screens/comment_screen.dart';
import 'package:instagram_clone/services/FirestoreService.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_down_button/pull_down_button.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;


  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    bool liked = widget.snap['likes'].contains(user!.uid);


    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap["username"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                PullDownButton(
                  itemBuilder: (context) => [
                    PullDownMenuItem(
                      onTap: () {},
                      title: "Delete",
                      icon: CupertinoIcons.delete,
                      isDestructive: true,
                    )
                  ],
                  buttonBuilder: (_, showMenu) => CupertinoButton(
                    onPressed: showMenu,
                    padding: EdgeInsets.zero,
                    pressedOpacity: 1,
                    child: const Icon(
                      Icons.more_vert,
                      color: primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          // Image Section
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreService().likePost(
                widget.snap['postId'],
                widget.snap['uid'],
                widget.snap['likes']
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap["postUrl"],
                    fit: BoxFit.cover,
                  ),
                ),

                AnimatedOpacity(
                  duration: const Duration(milliseconds: 100),
                  opacity: isLikeAnimating? 1: 0,
                  child: LikeAnimation(
                      isAnimating: isLikeAnimating,
                      smallLike: false,
                      duration: const Duration(
                        milliseconds: 100,
                      ),
                      onEnd: () {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                      child: const Icon(
                        CupertinoIcons.heart_fill,
                        color: Colors.white,
                        size: 100,
                      )
                  ),
                )
              ]
            ),
          ),
          //  Footer Section
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap["likes"].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreService().likePost(
                        widget.snap['postId'],
                        widget.snap['uid'],
                        widget.snap['likes']
                    );
                  },
                  icon: liked? const Icon(
                    CupertinoIcons.heart_fill,
                    color: Colors.red,
                  ) :const Icon(CupertinoIcons.heart),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => CommentsScreen(
                      snap: widget.snap,
                    )
                  )
                ),
                icon: const Icon(CupertinoIcons.text_bubble),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.paperplane),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(CupertinoIcons.bookmark),
                  ),
                ),
              )
            ],
          ),
          // Description and Comments
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  child: Text(
                    "${widget.snap["likes"].length} likes",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: primaryColor,
                      ),
                      children: [
                        TextSpan(
                          text: '${widget.snap["username"]}  ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold
                          )
                        ),
                        TextSpan(
                            text: widget.snap["description"],
                        )
                      ]
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: const Text(
                      "View All 200 comments",
                      style: TextStyle(
                        fontSize: 16,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd().format(DateTime.parse(widget.snap["datePublisher"] as String)),
                    style: const TextStyle(
                      fontSize: 16,
                      color: secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );

  }
}
