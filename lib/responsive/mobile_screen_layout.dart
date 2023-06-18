import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  final PageController _pageController = PageController();

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChange,
        physics: const NeverScrollableScrollPhysics(),
        children: homeScreenItems,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        onTap: navigationTapped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _page == 0? primaryColor: secondaryColor,
              ),
              backgroundColor: primaryColor
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: _page == 1? primaryColor: secondaryColor,
              ),
              backgroundColor: primaryColor
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: _page == 2? primaryColor: secondaryColor,
              ),
              backgroundColor: primaryColor
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: _page == 3? primaryColor: secondaryColor,
              ),
              backgroundColor: primaryColor
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: _page == 4? primaryColor: secondaryColor,
              ),
              backgroundColor: primaryColor
          ),
        ],
      ),
    );
  }
}
