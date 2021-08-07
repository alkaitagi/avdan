import 'package:avdan/data/chapter.dart';
import 'package:flutter/material.dart';
import 'item_card.dart';

class ChapterTabs extends AnimatedWidget {
  final List<Chapter> chapters;
  final TabController controller;

  ChapterTabs({
    required this.controller,
    required this.chapters,
  }) : super(listenable: controller.animation!);

  @override
  Widget build(BuildContext context) {
    final index = controller.animation?.value ?? 0;
    final highlight = Theme.of(context).highlightColor;

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(),
      elevation: 11,
      child: SizedBox(
        height: 98,
        child: TabBar(
          controller: controller,
          isScrollable: true,
          labelPadding: EdgeInsets.zero,
          indicatorPadding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 6,
          ),
          indicator: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            color: Color.lerp(
              chapters[index.floor()].color ?? highlight,
              chapters[index.ceil()].color ?? highlight,
              index.remainder(1),
            ),
          ),
          tabs: [
            for (var i = 0; i < chapters.length; i++)
              Builder(
                builder: (_) {
                  final chapter = chapters[i];
                  return AspectRatio(
                    aspectRatio: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: ItemCard(
                        color: chapter.color,
                        item: chapter.alphabet ? chapter.items.first : null,
                        image: chapter.alphabet
                            ? null
                            : chapter.getImageURL(chapter.items.first),
                        onTap: () => controller.animateTo(i),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
