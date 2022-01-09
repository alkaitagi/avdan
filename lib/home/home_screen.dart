import 'package:avdan/audio_player.dart';
import 'package:avdan/data/chapter.dart';
import 'package:avdan/data/translation.dart';
import 'package:avdan/home/chapter_tab_bar.dart';
import 'package:avdan/home/chapters_view.dart';
import 'package:avdan/home/items_view.dart';
import 'package:avdan/settings/settings_screen.dart';
import 'package:avdan/store.dart';
import 'package:avdan/widgets/label.dart';
import 'package:avdan/widgets/language_flag.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final List<Chapter> chapters;
  late Chapter chapter;

  @override
  void initState() {
    super.initState();
    final store = Provider.of<Store>(context, listen: false);
    chapters = store.chapters
        .where((i) => i.title.text(store.learning).isNotEmpty)
        .toList();
    chapter = chapters.first;

    _tabController = TabController(
      length: chapters.length,
      vsync: this,
    );
    _tabController.animation?.addListener(() {
      final index = _tabController.animation?.value.round() ?? 0;
      final chapter = chapters[index];
      if (this.chapter != chapter) {
        setState(() {
          this.chapter = chapter;
          playItem(
            Provider.of<Store>(context, listen: false).learning,
            chapter,
          );
        });
      }
    });
    playItemContext(context, chapter);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void playItemContext(
    BuildContext context,
    Chapter chapter, [
    Translation? item,
  ]) =>
      playItem(
        context.read<Store>().learning,
        chapter,
        item,
      );

  void openView(BuildContext context, Chapter chapter, int item) {
    final padding = EdgeInsets.only(
      top: MediaQuery.of(context).padding.top,
    );
    playItemContext(context, chapter, chapter.items[item]);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color.alphaBlend(
        chapter.color ?? Colors.transparent,
        Theme.of(context).colorScheme.surface,
      ),
      builder: (context) {
        return Padding(
          padding: padding,
          child: Stack(
            children: [
              ItemsView(
                chapter,
                initialItem: item,
                onChange: (i) => playItemContext(
                  context,
                  chapter,
                  chapter.items[i],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_outlined),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Stack(
          children: [
            Center(
              child: Opacity(
                opacity: .5,
                child: LanguageFlag(
                  context.watch<Store>().learning,
                  offset: const Offset(8, 0),
                ),
              ),
            )
          ],
        ),
        title: Label(
          chapter.title,
          titleSize: 20,
          subtitleSize: 16,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            color: Theme.of(context).colorScheme.onSurface,
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            ),
            visualDensity: const VisualDensity(horizontal: 2),
          ),
        ],
      ),
      body: ChaptersView(
        controller: _tabController,
        chapters: chapters,
        onTap: (chapter, item) => openView(context, chapter, item),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 98,
          child: ChapterTabBar(
            controller: _tabController,
            chapters: chapters,
            onTap: (i) {
              final chapter = chapters[i];
              if (chapter == this.chapter) {
                playItemContext(context, chapter);
              }
            },
          ),
        ),
      ),
    );
  }
}
