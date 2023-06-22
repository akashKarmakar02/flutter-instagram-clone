import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key});

  @override
  Widget build(BuildContext context) {
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
                const CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage('https://www.photoshopbuzz.com/wp-content/uploads/change-color-part-of-image-psd4.jpg'),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'username',
                          style: TextStyle(
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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.network(
              'https://www.photoshopbuzz.com/wp-content/uploads/change-color-part-of-image-psd4.jpg',
              fit: BoxFit.cover,
            ),
          ),
          //  Footer Section
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.heart),
              ),
              IconButton(
                onPressed: () {},
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
                    "1,231 likes",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        color: primaryColor,
                      ),
                      children: [
                        TextSpan(
                          text: 'username  ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          )
                        ),
                        TextSpan(
                            text: 'Hey, This is a description to be replaced!',
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
                  child: const Text(
                    "19/06/2023",
                    style: TextStyle(
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
