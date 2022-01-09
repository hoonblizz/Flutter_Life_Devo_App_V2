import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/controllers/main/main_controller.dart';
import 'package:flutter_life_devo_app_v2/views/chat/chat_page.dart';
import 'package:flutter_life_devo_app_v2/views/contents/contents_page.dart';
import 'package:flutter_life_devo_app_v2/views/home/home_page.dart';
import 'package:flutter_life_devo_app_v2/views/life_devo/life_devo_page.dart';
import 'package:flutter_life_devo_app_v2/views/profile/profile_page.dart';
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
  final MainController _mainController = Get.find();
  //final GlobalController _globalController = Get.find<GlobalController>();
  final GlobalController _globalController = Get.find();

  int _currentBottomTabIndex = 0;

  final List<Widget> _pages = <Widget>[
    HomePage(),
    ContentsPage(),
    LifeDevoPage(),
    ChatPage(),
    ProfilePage()
  ];

  void _onSelectBottomTab(int index) {
    setState(() {
      _currentBottomTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navBG,
      body: Container(
        color: navBG,
        // 각 탭에서 로딩을 핸들링 하기로 바꿔서, 이것도 각 탭으로 옮겨준다.
        // padding: EdgeInsets.symmetric(
        //   horizontal: screenPaddingHorizontal,
        // ),
        child: SafeArea(
          child: _pages.elementAt(_currentBottomTabIndex),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: screenPaddingHorizontal),
        decoration: const BoxDecoration(
          border: Border(
              top: BorderSide(
            color: kPrimaryColor,
            width: 1,
          )),
        ),
        child: BottomNavigationBar(
          elevation: 0,
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
              label: "Contents",
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
                Icons.people,
                size: navIcon,
              ),
              label: "People",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
                size: navIcon,
              ),
              label: "Profile",
            ),
          ],
          currentIndex: _currentBottomTabIndex,
          onTap: _onSelectBottomTab,
        ),
      ),
    );
  }
}
