import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_app/pages/anime_types/anime_types_page.dart';
import 'package:flutter_video_app/pages/dash/dash.store.dart';
import 'package:flutter_video_app/pages/home/home_page.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/pages/recently_updated/recently_updated_page.dart';
import 'package:flutter_video_app/pages/recommend/recommend_page.dart';

class DashPage extends StatefulWidget {
  @override
  _DashPageState createState() => _DashPageState();
}

class _DashPageState extends State<DashPage> {
  final store = DashStore();

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Observer(
        builder: (_) => BubbleBottomBar(
          opacity: 0.2,
          currentIndex: store.index,
          onTap: store.controller.jumpToPage,
          borderRadius: BorderRadius.circular(16),
          hasNotch: true,
          hasInk: true,
          inkColor: Colors.black12,
          items: <BubbleBottomBarItem>[
            for (var e in store.navList)
              BubbleBottomBarItem(
                backgroundColor: e.color,
                icon: Icon(
                  e.icon,
                  color: Colors.black,
                ),
                activeIcon: Icon(
                  e.icon,
                  color: e.color,
                ),
                title: Text(e.title),
              ),
          ],
        ),
      ),
      body: PageView(
        controller: store.controller,
        onPageChanged: store.onPageChanged,
        children: <Widget>[
          HomePage(),
          RecentlyUpdatedPage(),
          RecommendPage(),
          AnimeTypesPage(),
        ],
      ),
    );
  }
}
