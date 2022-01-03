import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/home/home_controller.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/theme/app_sizes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _homeController = Get.find<HomeController>();
  final GlobalController _globalController = Get.find<GlobalController>();

  int _currentBottomTabIndex = 0;

  static const List<Widget> _pages = <Widget>[
    // Services(),
    // Requests(),
    // Portfolio(),
    // Inbox(),
    // BusinessProfile(),
  ];

  void _onSelectBottomTab(int index) {
    //print('Received Index: $index');
    setState(() {
      _currentBottomTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_currentBottomTabIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          // ignore: prefer_const_literals_to_create_immutables
          boxShadow: [
            const BoxShadow(
                color: Colors.black26, spreadRadius: -5, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            backgroundColor: navBG,
            selectedItemColor: navSelected,
            unselectedItemColor: navUnselected,
            type: BottomNavigationBarType.shifting,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.volunteer_activism,
                  size: navIcon,
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.room_service,
                  size: navIcon,
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.photo,
                  size: navIcon,
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat,
                  size: navIcon,
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  size: navIcon,
                ),
                label: "",
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
