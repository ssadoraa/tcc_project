import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcc_project/pages/details_page.dart';
import 'package:tcc_project/services/attraction_service.dart';
import 'package:tcc_project/theme/app_colors.dart';
import 'package:tcc_project/widgets/qr_scanner.dart';

class AttractionPage extends StatefulWidget {
  AttractionPage({Key? key}) : super(key: key);

  @override
  _AttractionPageState createState() => _AttractionPageState();
}

class _AttractionPageState extends State<AttractionPage> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final AttractionService _attractionservice = AttractionService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Pesquise pelo lugar...',
                hintStyle: TextStyle(color: AppColors.textSecondary),
                prefixIcon: Icon(Icons.search, color: AppColors.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.lightOrangeOpacity,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _attractionservice.getattractions(),
              builder: (context, attractionsnapshot) {
                if (!attractionsnapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final attractions = attractionsnapshot.data!.docs;

                return StreamBuilder<Set<String>>(
                  stream: _attractionservice.getunlockedAttractions(userId),
                  builder: (context, unlockedSnapshot) {
                    if (!unlockedSnapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final unlocked = unlockedSnapshot.data!;
                    final searchQuery = _searchController.text
                        .toLowerCase()
                        .trim();

                    final filteredAttractions = attractions.where((attraction) {
                      final data = attraction.data() as Map<String, dynamic>;
                      final title = (data["titulo"] ?? "")
                          .toString()
                          .toLowerCase();
                      return title.contains(searchQuery);
                    }).toList();

                    final total = attractions.length;
                    final unlockedCount = unlocked.length;
                    final progress = total > 0 ? unlockedCount / total : 0.0;

                    return Column(
                      children: [
                        _buildProgressBar(progress, unlockedCount, total),
                        Expanded(
                          child: filteredAttractions.isEmpty
                              ? Center(
                                  child: Text(
                                    'Nenhum ponto encontrado.',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                )
                              : _buildAttractionGrid(
                                  context,
                                  filteredAttractions,
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
      floatingActionButton: SizedBox(
        height: 65,
        width: 65,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => QRScannerPage()),
            );
          },
          shape: CircleBorder(),
          backgroundColor: AppColors.secondaryStrong,
          child: Icon(
            Icons.qr_code_scanner,
            size: 28,
            color: AppColors.white,
          ),
        ),
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
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 15,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 1 ? AppColors.lightGreen : AppColors.primaryStrong,
              ),
            ),
          ),
          SizedBox(height: 5),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              '$unlocked/$total',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttractionGrid(
    BuildContext context,
    List<QueryDocumentSnapshot> attractions,
    Set<String> unlocked,
  ) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (MediaQuery.of(context).size.width / 150).floor().clamp(
          2,
          6,
        ),
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: attractions.length,
      itemBuilder: (context, index) {
        final attraction = attractions[index];
        final data = attraction.data() as Map<String, dynamic>;
        final isUnlocked = unlocked.contains(attraction.id);

        return _buildAttractionCard(context, attraction.id, data, isUnlocked);
      },
    );
  }

  Widget _buildAttractionCard(
    BuildContext context,
    String attractionId,
    Map<String, dynamic> data,
    bool isUnlocked,
  ) {
    final cardColor = isUnlocked
        ? AppColors.background
        : AppColors.lightOrangeOpacity.withOpacity(0.4);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: isUnlocked
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(attractionId: attractionId),
                ),
              );
            }
          : null,
      child: Card(
        color: cardColor,
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
                      color: isUnlocked ? null : AppColors.black.withOpacity(0.4),
                      colorBlendMode: isUnlocked ? null : BlendMode.darken,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    data["titulo"] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isUnlocked
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    "Clique para ver detalhes",
                    style: TextStyle(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            if (!isUnlocked)
              Center(
                child: Icon(
                  Icons.lock,
                  size: 40,
                  color: AppColors.textThird,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: AppColors.black.withOpacity(0.4),
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
