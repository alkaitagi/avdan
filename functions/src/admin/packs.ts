/* eslint-disable @typescript-eslint/no-non-null-assertion */
/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable require-jsdoc */
import {default as admin, firestore} from "./init";


run();
async function run() {
  const langs = [
    // "abkhaz",
    // "aghul",
    // "dargwa",
    // "digor",
    // "iron",
    // "east circassian",
    "kaitag",
    // "kubachi",
    // "kumyk",
  ];
  for (const l of langs) {
    await clean(l);
    await upload(l);
  }
}

async function clean(lang: string) {
  const packs = await firestore
      .collection(`languages/${lang}/packs`)
      .listDocuments();
  for (const p of packs) {
    await firestore.recursiveDelete(p);
  }
}

async function upload(lang: string) {
  // eslint-disable-next-line @typescript-eslint/no-var-requires
  const data = require(`./assets/packs/${lang}.json`);
  let i = 0;
  for (const d of data) {
    const pack = {
      "order": i++,
      "length": d.length,
      "status": "updating",
    } as any;
    if (d.color) pack.color = d.color;
    const pRef = await firestore
        .collection(`languages/${lang}/packs`)
        .add(pack);

    let coverId = "";
    for (let i = 0; i < d.cards.length; i++) {
      await uploadCard(pRef, {
        order: i,
        ...d.cards[i],
      }).then((id) => {
        if (!i) {
          coverId = id;
        }
      });
    }

    pRef.update({
      coverId,
      "lastUpdated": admin.firestore.FieldValue.serverTimestamp(),
      "status": "public",
    });
  }
  await firestore
      .doc(`languages/${lang}`)
      .update({
        "lastUpdated": admin.firestore.FieldValue.serverTimestamp(),
      });
}

async function uploadCard(pRef: admin.firestore.DocumentReference, card:any) {
  const translations = card.translations;
  delete card.translations;
  const cardId = await pRef.collection("cards").add(card).then((r) => r.id);
  if (translations) {
    for (const t of translations) {
      pRef.collection("translations")
          .add({...t, cardId});
    }
  }
  return cardId;
}
