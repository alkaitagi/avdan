import 'package:avdan/audio_player.dart';
import 'package:avdan/data/chapter.dart';
import 'package:avdan/data/translation.dart';
import 'package:avdan/store.dart';
import 'package:avdan/settings/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chapter_list.dart';
import 'item_grid.dart';
import 'item_view.dart';
import 'package:avdan/widgets/language_flag.dart';
import 'package:avdan/widgets/language_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Chapter chapter = Store.chapters[0];
  Translation item = Store.chapters[0].items[0];

  final PageController _pageController = PageController();

  void openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsScreen(),
      ),
    ).then(
      (_) => setState(() {}),
    );
  }

  void openPage(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 200),
      curve: standardEasing,
    );
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getString('interface') == null) openSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Stack(
          children: [
            Center(
              child: LanguageFlag(
                Store.learning,
                offset: Offset(16, 0),
              ),
            )
          ],
        ),
        title: Center(
          child: LanguageTitle(
            Store.learning,
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined),
            onPressed: openSettings,
            visualDensity: VisualDensity(horizontal: 2),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                ItemsGrid(
                  chapter,
                  onSelect: (i) {
                    setState(() {
                      item = i;
                    });
                    openPage(1);
                    playItem(chapter, item);
                  },
                ),
                ItemView(
                  chapter: chapter,
                  item: item,
                  actions: IconButton(
                    icon: Icon(Icons.arrow_back_outlined),
                    onPressed: () => openPage(0),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.25),
                  blurRadius: 2,
                )
              ],
            ),
            child: ChapterList(
              Store.chapters,
              selected: chapter,
              onSelect: (c) {
                openPage(0);
                setState(() => chapter = c);
              },
            ),
          ),
        ],
      ),
    );
  }
}
