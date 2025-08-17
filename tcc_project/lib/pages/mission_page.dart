import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcc_project/pages/details_page.dart';
import 'package:tcc_project/widgets/qr_scanner.dart';

class MissionPage extends StatefulWidget {
  MissionPage({Key? key}) : super(key: key);

  @override
  _MissionPageState createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mission Page')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('missions').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final missions = snapshot.data!.docs;

          return StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('users')
                .doc(userId)
                .collection('unlockedMissions')
                .snapshots(),
            builder: (context, unlockedSnapshot) {
              if (!unlockedSnapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final unlocked = unlockedSnapshot.data!.docs.map((d) => d.id).toSet();

              return GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (MediaQuery.of(context).size.width / 150).floor().clamp(2, 6),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: missions.length,
                itemBuilder: (context, index) {
                  final mission = missions[index];
                  final data = mission.data() as Map<String, dynamic>;

                  final isUnlocked = unlocked.contains(mission.id);

                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: isUnlocked
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsPage(missionId: mission.id),
                              ),
                            );
                          }
                        : null,
                    child: Card(
                      color: isUnlocked ? Colors.white : Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                  child: Image.network(
                                    data["image"] ?? "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=60",
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    color: isUnlocked ? null : Colors.black.withOpacity(0.5),
                                    colorBlendMode: isUnlocked ? null : BlendMode.darken,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 13, left: 8, right: 8),
                                child: Text(
                                  data["titulo"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isUnlocked ? Colors.black : Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8, right: 8, bottom: 5, top: 8),
                                child: Text(
                                  "Clique para ver detalhes",
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                            ],
                          ),
                          if (!isUnlocked)
                            Center(
                              child: Icon(
                                Icons.lock,
                                size: 40,
                                color: Colors.white),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => QRScannerPage()),
          );
        },
        child: Icon(Icons.qr_code_scanner),
      ),
    );
  }
}
