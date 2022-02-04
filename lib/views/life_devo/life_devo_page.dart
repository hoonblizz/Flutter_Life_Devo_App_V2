/*
  Life devo 리스트 페이지를 말한다.
*/
import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/views/life_devo/life_devo_all/life_devo_all_page.dart';
import 'package:flutter_life_devo_app_v2/views/life_devo/life_devo_my/life_devo_my_page.dart';
import 'package:flutter_life_devo_app_v2/views/life_devo/life_devo_shared/life_devo_shared.dart';

// ignore: use_key_in_widget_constructors
class LifeDevoPage extends StatelessWidget {
  //const LifeDevoPage({Key? key}) : super(key: key);
  //final TabController _tabController = TabController();

  final _upperTab = TabBar(
    //isScrollable: true,
    indicatorColor: navBG,
    indicatorWeight: 3,
    tabs: const <Tab>[
      Tab(
        child: Text('All'),
      ),
      Tab(
        child: Text('My'),
      ),
      Tab(child: Text('Shared')),
    ],
  );

  final _tabbarView = TabBarView(
    children: [
      LifeDevoAllPage(),
      Container(
        child: Text('1'),
      ),
      Container(
        child: Text('2'),
      ),
      //LifeDevoMyPage(),
      //LifeDevoSharedPage(),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          //foregroundColor: kSecondaryColor,
          automaticallyImplyLeading: false,
          title: _upperTab,
          elevation: 5,
          //bottom: upperTab,
        ),
        body: _tabbarView,
      ),
    );
  }
}
