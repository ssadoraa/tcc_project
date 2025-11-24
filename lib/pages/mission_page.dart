import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcc_project/pages/details_page.dart';
import 'package:tcc_project/services/mission_service.dart';
import 'package:tcc_project/theme/app_colors.dart';
import 'package:tcc_project/widgets/qr_scanner.dart';

class MissionPage extends StatefulWidget {
  MissionPage({Key? key}) : super(key: key);

  @override
  _MissionPageState createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final MissionService _missionService = MissionService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Buscar missão...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.secondary,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _missionService.getMissions(),
              builder: (context, missionSnapshot) {
                if (!missionSnapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final missions = missionSnapshot.data!.docs;

                return StreamBuilder<Set<String>>(
                  stream: _missionService.getUnlockedMissions(userId),
                  builder: (context, unlockedSnapshot) {
                    if (!unlockedSnapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final unlocked = unlockedSnapshot.data!;
                    final searchQuery = _searchController.text.toLowerCase().trim();

                    final filteredMissions = missions.where((mission) {
                      final data = mission.data() as Map<String, dynamic>;
                      final title = (data["titulo"] ?? "")
                          .toString()
                          .toLowerCase();

                      return title.contains(searchQuery);
                    }).toList();

                    final total = missions.length;
                    final unlockedCount = unlocked.length;
                    final progress = total > 0 ? unlockedCount / total : 0.0;

                    return Column(
                      children: [
                        _buildProgressBar(progress, unlockedCount, total),

                        Expanded(
                          child: filteredMissions.isEmpty
                              ? Center(
                                  child: Text(
                                    'Nenhuma missão encontrada.',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : _buildMissionGrid(
                                  context,
                                  filteredMissions,
                                  unlocked,
                                ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => QRScannerPage()),
          );
        },
        backgroundColor: AppColors.secondary,
        child: Icon(Icons.qr_code_scanner),
      ),
    );
  }

  Widget _buildProgressBar(double progress, int unlocked, int total) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 15,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 1
                    ? const Color.fromARGB(255, 133, 205, 135)
                    : const Color.fromARGB(255, 112, 153, 222),
              ),
            ),
          ),
          SizedBox(height: 5),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              '$unlocked/$total',
              style: TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionGrid(
    BuildContext context,
    List<QueryDocumentSnapshot> missions,
    Set<String> unlocked,
  ) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            (MediaQuery.of(context).size.width / 150).floor().clamp(2, 6),
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: missions.length,
      itemBuilder: (context, index) {
        final mission = missions[index];
        final data = mission.data() as Map<String, dynamic>;
        final isUnlocked = unlocked.contains(mission.id);

        return _buildMissionCard(
          context,
          mission.id,
          data,
          isUnlocked,
        );
      },
    );
  }

  Widget _buildMissionCard(
    BuildContext context,
    String missionId,
    Map<String, dynamic> data,
    bool isUnlocked,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: isUnlocked
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(missionId: missionId),
                ),
              );
            }
          : null,
      child: Card(
        color: isUnlocked ? Colors.white : Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      data["image"] ??
                          "https://images.unsplash.com/photo-1506744038136-46273834b3fb",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      color: isUnlocked ? null : Colors.black.withOpacity(0.5),
                      colorBlendMode:
                          isUnlocked ? null : BlendMode.darken,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    data["titulo"] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isUnlocked ? Colors.black : Colors.grey[600],
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    "Clique para ver detalhes",
                    style: TextStyle(fontSize: 9, color: Colors.grey),
                  ),
                ),
              ],
            ),

            if (!isUnlocked)
              Center(
                child: Icon(Icons.lock, size: 40, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
