const admin = require("firebase-admin");
const serviceAccount = require("../json/keys/pk_firebase.json");
const fs = require("fs");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();
const data = JSON.parse(fs.readFileSync("../json/missions.json", "utf8"));

async function importar() {
  const batch = db.batch();
  const collection = db.collection("missions");

  data.forEach((ponto) => {
    // Usa o título como ID do documento
    const docRef = collection.doc(ponto.titulo); 
    batch.set(docRef, ponto, { merge: true });
  });

  await batch.commit();
  console.log(`✅ ${data.length} pontos turísticos importados/atualizados com sucesso!`);
}

importar().catch(console.error);
