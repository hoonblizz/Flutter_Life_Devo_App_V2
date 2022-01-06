import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/views/home/home_page.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/theme/app_sizes.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalController _globalController = Get.find<GlobalController>();

  int _currentBottomTabIndex = 0;

  final List<Widget> _pages = <Widget>[
    HomePage(),
  ];

  void _onSelectBottomTab(int index) {
    setState(() {
      _currentBottomTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_currentBottomTabIndex),
      bottomNavigationBar: Container(
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(30),
        //   // ignore: prefer_const_literals_to_create_immutables
        //   boxShadow: [
        //     const BoxShadow(
        //         color: Colors.black26, spreadRadius: -5, blurRadius: 10),
        //   ],
        // ),

        margin: EdgeInsets.symmetric(horizontal: screenPaddingHorizontal),
        decoration: const BoxDecoration(
          border: Border(
              top: BorderSide(
            color: kPrimaryColor,
            width: 1,
          )),
        ),
        child: ClipRRect(
          //borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            backgroundColor: navBG,
            selectedItemColor: navSelected,
            unselectedItemColor: navUnselected,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: navIcon,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.video_library,
                  size: navIcon,
                ),
                label: "Sermon",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.auto_stories,
                  size: navIcon,
                ),
                label: "Life Devo",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle,
                  size: navIcon,
                ),
                label: "Profile",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu,
                  size: navIcon,
                ),
                label: "Menu",
              ),
            ],
            currentIndex: _currentBottomTabIndex,
            onTap: _onSelectBottomTab,
          ),
        ),
      ),
    );
  }
}
