import 'package:avdan/data/chapter.dart';
import 'package:avdan/data/translation.dart';
import 'item_card.dart';
import 'package:flutter/material.dart';

class ItemsGrid extends StatelessWidget {
  final Chapter chapter;
  final ValueSetter<Translation>? onSelect;

  ItemsGrid(this.chapter, {this.onSelect});

  @override
  Widget build(BuildContext context) {
    final items = chapter.items.where((i) => i.learning != null).toList();
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: chapter.alphabet ? 128 : 256,
        childAspectRatio: chapter.alphabet ? 1 : 1.25,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ItemCard(
          item: item,
          image: chapter.alphabet ? null : chapter.getImageURL(item),
          onTap: () => onSelect?.call(item),
        );
      },
    );
  }
}
