/* eslint-disable @typescript-eslint/no-non-null-assertion */
/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable require-jsdoc */
import { bucket } from "./init";
import glob from "glob";

run();
async function run() {
  const dir = "audios/kaitag";
  await clean(dir);
  await upload(dir);
}

async function clean(dir = "") {
  await bucket.deleteFiles({
    prefix: `static/${dir}`,
  });
}

async function upload(dir = "") {
  console.log('upload')
  glob(`assets/static/${dir}/**/*.{png,mp3}`, async (_, files) => {
    for (const file of files) {
      const destination = file.substring(7);
      await bucket.upload(file, { destination });
      console.log(destination);
    }
  });
}
