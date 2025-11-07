const admin = require("firebase-admin");
const serviceAccount = require("../json/keys/pk_firebase.json");
const fs = require("fs");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function importarColecao(nomeArquivo, nomeColecao, campoId) {
  const data = JSON.parse(fs.readFileSync(`../json/${nomeArquivo}.json`, "utf8"));
  const batch = db.batch();
  const collection = db.collection(nomeColecao);

  data.forEach((item) => {
    const id = item[campoId];
    if (!id) {
      console.warn(`⚠️ Item sem campo '${campoId}', ignorado:`, item);
      return;
    }

    const docRef = collection.doc(id.toString());
    batch.set(docRef, item, { merge: true });
  });

  await batch.commit();
  console.log(`✅ ${data.length} itens importados/atualizados na coleção "${nomeColecao}"`);
}

async function importarTudo() {
  try {
    await importarColecao("guides", "guides", "cad");
    await importarColecao("missions", "missions", "qr_code");
    console.log("🚀 Importação completa!");
  } catch (err) {
    console.error("❌ Erro na importação:", err);
  }
}

importarTudo();
