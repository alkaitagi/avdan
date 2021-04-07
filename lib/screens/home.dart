import 'dart:async';

import 'package:avdan/data/chapter.dart';
import 'package:avdan/data/store.dart';
import 'package:avdan/screens/settings.dart';
import 'package:avdan/widgets/chapter_list.dart';
import 'package:avdan/widgets/item_grid.dart';
import 'package:avdan/widgets/item_card.dart';
import 'package:avdan/widgets/item_view.dart';
import 'package:avdan/widgets/label.dart';
import 'package:avdan/widgets/language_flag.dart';
import 'package:avdan/widgets/language_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeScreenState() {
    Timer(
      Duration(),
      loadLanguages,
    );
  }

  Chapter chapter = chapters[0];
  Map<String, String> item = chapters[0].items[0];

  final PageController _pageController = PageController();

  loadLanguages() async {
    final prefs = await SharedPreferences.getInstance();
    var il = findLanguage(
      prefs.getString('interfaceLanguage'),
    );
    var ll = findLanguage(
      prefs.getString('learningLanguage'),
    );

    if (il == null || ll == null)
      openSettings();
    else
      setState(() {
        interfaceLanguage = il;
        learningLanguage = ll;
      });
  }

  openSettings() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsScreen(),
        ),
      ).then(
        (v) => setState(() {}),
      );

  openPage(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: standardEasing,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: LanguageTitle(learningLanguage),
        actions: [
          Stack(
            children: [
              Center(
                child: LanguageFlag(
                  learningLanguage,
                  offset: Offset(-64, 0),
                ),
              )
            ],
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: openSettings,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 4,
                )
              ],
            ),
            child: ChapterList(
              chapters,
              selected: chapter,
              onSelect: (c) {
                openPage(0);
                if (chapter != c) setState(() => chapter = c);
              },
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                ItemsGrid(
                  chapter,
                  selected: item,
                  onSelect: (i) {
                    openPage(1);
                    if (item != i) setState(() => item = i);
                  },
                ),
                ItemView(
                  item,
                  actions: IconButton(
                    icon: Icon(Icons.grid_view),
                    onPressed: () => openPage(0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
