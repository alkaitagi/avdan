import 'package:avdan/models/card.dart';
import 'package:avdan/models/pack.dart';
import 'package:avdan/shared/contents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/deck_preview.dart';

Future<List<Card>> fetchCards(
  String language,
  String packId,
) async {
  return FirebaseFirestore.instance
      .collection('languages/$language/packs/$packId/cards')
      .withConverter<Card>(
        fromFirestore: (snapshot, _) => Card.fromJson({
          'id': snapshot.id,
          ...snapshot.data()!,
        }),
        toFirestore: (object, _) => object.toJson(),
      )
      .get()
      .then((s) => s.docs.map((d) => d.data()).toList());
}

Future<void> saveAssets(
  String language,
  Card card, [
  bool audio = true,
]) async {
  if (card.imagePath != null) {
    await putAsset(
      card.imagePath!,
      await FirebaseStorage.instance
          .ref('static/images/${card.imagePath}')
          .getData()
          .onError((error, stackTrace) => null),
    );
  }
  if (audio && card.audioPath != null) {
    await putAsset(
      card.audioPath!,
      await FirebaseStorage.instance
          .ref('static/audios/$language/${card.audioPath}')
          .getData()
          .onError((error, stackTrace) => null),
    );
  }
}

Future<String?> fetchTranslation(
  String language,
  String translationLanguage,
  String packId,
  String cardId,
) {
  return FirebaseFirestore.instance
      .collection('languages/$language/packs/$packId/translations')
      .where('cardId', isEqualTo: cardId)
      .where('language', isEqualTo: translationLanguage)
      .limit(1)
      .get()
      .then((s) => s.size == 0 ? null : s.docs.first.get('text') as String);
}

Future<DeckPreview> fetchDeckPreview(
  String language,
  String translationLanguage,
  Pack pack,
) async {
  final cover = await FirebaseFirestore.instance
      .doc('languages/$language/packs/${pack.id}/cards/${pack.coverId}')
      .withConverter<Card>(
        fromFirestore: (snapshot, _) => Card.fromJson({
          'id': snapshot.id,
          ...snapshot.data()!,
        }),
        toFirestore: (object, _) => object.toJson(),
      )
      .get()
      .then((d) => d.data()!);
  await saveAssets(language, cover, false);
  return DeckPreview(
    pack: pack,
    cover: cover,
    length: pack.length,
    translation: await fetchTranslation(
      language,
      translationLanguage,
      pack.id,
      cover.id,
    ),
  );
}
