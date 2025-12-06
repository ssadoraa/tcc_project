const admin = require("firebase-admin");
const serviceAccount = require("../json/keys/pk_firebase.json");
const fs = require("fs");
const path = require("path");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: "desengo-app.firebasestorage.app"
});

const db = admin.firestore();
const bucket = admin.storage().bucket();

async function arquivoExiste(caminhoNoStorage) {
  const file = bucket.file(caminhoNoStorage);
  const [existe] = await file.exists();
  return existe;
}

async function gerarUrlDownload(caminhoNoStorage) {
  const file = bucket.file(caminhoNoStorage);
  try {
    const [url] = await file.getSignedUrl({
      action: "read",
      expires: "03-01-2030",
    });
    return url;
  } catch {
    return null;
  }
}

async function uploadImagem(caminhoLocal, caminhoNoStorage) {
  try {
    await bucket.upload(caminhoLocal, {
      destination: caminhoNoStorage,
      metadata: { cacheControl: "public,max-age=31536000" },
    });
  } catch {}
}

async function importarColecao(nomeArquivo, nomeColecao, campoId) {
  const data = JSON.parse(fs.readFileSync(`../json/${nomeArquivo}.json`, "utf8"));
  const batch = db.batch();
  const collection = db.collection(nomeColecao);

  for (const item of data) {
    const id = item[campoId];
    if (!id) continue;

    if (item.imageName) {
      const caminhoLocal = path.join("D:\\UFF\\7 - Semestre\\TCC\\Images", nomeColecao, item.imageName);
      const caminhoNoStorage = `${nomeColecao}/${item.imageName}`;

      const arquivoLocalExiste = fs.existsSync(caminhoLocal);
      const existe = await arquivoExiste(caminhoNoStorage);

      if (!existe && arquivoLocalExiste) {
        await uploadImagem(caminhoLocal, caminhoNoStorage);
      }

      const url = await gerarUrlDownload(caminhoNoStorage);
      if (url) item.imageUrl = url;
    }

    const docRef = collection.doc(id.toString());
    batch.set(docRef, item, { merge: true });
  }

  await batch.commit();
}

async function importarTudo() {
  try {
    await importarColecao("guides", "guides", "cad");
    await importarColecao("attractions", "attractions", "qr_code");
    await importarColecao("infos", "infos", "id");
    await importarColecao("events", "events", "id");
  } catch {}
}

importarTudo();