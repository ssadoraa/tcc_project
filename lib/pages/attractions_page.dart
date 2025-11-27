import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcc_project/controller/attraction_controller.dart';
import 'package:tcc_project/model/attraction.dart';
import 'package:tcc_project/services/attraction_service.dart';
import 'package:tcc_project/widgets/qr_scanner.dart';
import 'package:tcc_project/pages/details_page.dart';
import 'package:tcc_project/theme/app_colors.dart';

class AttractionPage extends StatefulWidget {
  @override
  _AttractionPageState createState() => _AttractionPageState();
}

class _AttractionPageState extends State<AttractionPage> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  late final AttractionController controller;
  final searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = AttractionController(AttractionService());
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Column(
        children: [
          SizedBox(height: 15),
          _buildSearchField(),
          Expanded(
            child: StreamBuilder<List<Attraction>>(
              stream: controller.getAttractions(),
              builder: (context, attractionsSnap) {
                if (!attractionsSnap.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final allAttractions = attractionsSnap.data!;

                return StreamBuilder<Set<String>>(
                  stream: controller.getUnlocked(userId),
                  builder: (context, unlockedSnap) {
                    if (!unlockedSnap.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final unlocked = unlockedSnap.data!;

                    final filtered = controller.filter(
                      allAttractions,
                      searchCtrl.text,
                    );

                    final progress = controller.getProgress(
                      unlocked.length,
                      allAttractions.length,
                    );

                    return Column(
                      children: [
                        _buildProgress(
                          progress,
                          unlocked.length,
                          allAttractions.length,
                        ),
                        Expanded(
                          child: filtered.isEmpty
                              ? Center(
                                  child: Text(
                                    "Nenhum ponto encontrado.",
                                    style: TextStyle(
                                      color: AppColors.textSecondary(context),
                                    ),
                                  ),
                                )
                              : _buildGrid(filtered, unlocked),
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
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: searchCtrl,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Pesquise pelo lugar...',
          prefixIcon: Icon(Icons.search, color: AppColors.primary(context)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.lightOrangeOpacity(context),
        ),
      ),
    );
  }

  Widget _buildProgress(double progress, int unlocked, int total) {
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
              backgroundColor: AppColors.border(context),
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 1 ? AppColors.lightGreen(context) : AppColors.primaryStrong(context),
              ),
            ),
          ),
          SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "$unlocked/$total",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List<Attraction> list, Set<String> unlocked) {
    return GridView.builder(
      padding: EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (MediaQuery.of(context).size.width / 150).floor().clamp(
          2,
          6,
        ),
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: list.length,
      itemBuilder: (context, i) {
        final a = list[i];
        final isUnlocked = unlocked.contains(a.id);

        return _buildCard(a, isUnlocked);
      },
    );
  }

  Widget _buildCard(Attraction a, bool isUnlocked) {
    return InkWell(
      onTap: isUnlocked
          ? () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailsPage(attractionId: a.id),
              ),
            )
          : null,
      borderRadius: BorderRadius.circular(20),
      child: Card(
        color: isUnlocked
            ? AppColors.lightOrangeOpacity(context).withOpacity(0.5)
            : AppColors.earthBrown(context).withOpacity(0.7),
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
                      a.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      color: isUnlocked ? null : AppColors.black(context).withOpacity(0.4),
                      colorBlendMode: isUnlocked ? null : BlendMode.darken,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=60',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          color: isUnlocked
                              ? null
                              : AppColors.black(context).withOpacity(0.4),
                          colorBlendMode: isUnlocked ? null : BlendMode.darken,
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Text(
                        a.titulo,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isUnlocked
                              ? AppColors.textPrimary(context)
                              : AppColors.textSecondary(context),
                        ),
                      ),
                      if (isUnlocked)
                        Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Text(
                            "Clique para ver detalhes",
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
              ],
            ),
            if (!isUnlocked)
              Center(
                child: Icon(Icons.lock, size: 40, color: AppColors.textThird(context)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return SizedBox(
      height: 65,
      width: 65,
      child: FloatingActionButton(
        backgroundColor: AppColors.secondaryStrong(context),
        shape: CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => QRScannerPage()),
          );
        },
        child: Icon(Icons.qr_code_scanner, size: 28, color: AppColors.white(context)),
      ),
    );
  }
}
