import 'dart:math';
import 'package:avdan/data/language.dart';
import 'package:avdan/widgets/language_flag.dart';
import 'package:avdan/widgets/language_title.dart';
import 'package:avdan/widgets/selectable_card.dart';
import 'package:flutter/material.dart';

class LanguageCard extends StatelessWidget {
  const LanguageCard(
    this.language, {
    this.selected = false,
    this.alt,
    this.onTap,
  });
  final Language language;
  final bool selected;
  final bool? alt;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final size = 24.0;
    final offset = 6.0;
    return AspectRatio(
      aspectRatio: 1.6,
      child: SelectableCard(
        onTap: onTap,
        selected: selected,
        elevated: true,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: LanguageFlag(
              language,
              offset: Offset(-28, 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: LanguageTitle(language),
          ),
          AnimatedPositioned(
            left: alt != null ? size - offset : -size - offset,
            bottom: 0,
            duration: Duration(milliseconds: 250),
            curve: standardEasing,
            child: Container(
              width: size + offset,
              height: size,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4),
                  topLeft: Radius.circular(4),
                ),
              ),
              padding: EdgeInsets.only(left: offset),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 350),
                curve: standardEasing,
                transformAlignment: Alignment.center,
                transform: Matrix4.rotationZ(alt != null && alt! ? 0 : pi),
                child: Icon(
                  Icons.swap_horiz_outlined,
                  size: size - 2,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
