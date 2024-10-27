import * as admin from "firebase-admin";

admin.initializeApp({
  credential: admin.credential.cert("./serviceAccountKey.json"),
  storageBucket: "avdan-918fc.appspot.com",
});

export default admin;
export const storage = admin.storage();
export const firestore = admin.firestore();
export const bucket = storage.bucket();
