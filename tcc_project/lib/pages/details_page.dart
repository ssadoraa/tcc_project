import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc_project/theme/app_colors.dart';

class DetailsPage extends StatelessWidget {
  final String missionId;

  DetailsPage({Key? key, required this.missionId}) : super(key: key);

  Widget buildSection(String title, Widget child) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          child,
        ],
      ),
    );
  }

  Widget buildMainInfo(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 28, color: AppColors.primary),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      ],
    );
  }

  Widget buildAltitudeInfo(int inicial, int maxima, int finalAlt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Icon(Icons.arrow_upward),
            SizedBox(height: 4),
            Text("$inicial m", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              "Inicial",
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ],
        ),
        Column(
          children: [
            Icon(Icons.terrain),
            SizedBox(height: 4),
            Text("$maxima m", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              "Máxima",
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ],
        ),
        Column(
          children: [
            Icon(Icons.arrow_downward),
            SizedBox(height: 4),
            Text("$finalAlt m", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              "Final",
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            SizedBox(width: 8),
            Text(text, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget buildTagRow(List<dynamic> items) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: items
          .map(
            (item) => Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(item, style: TextStyle(fontSize: 14)),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalhes da Missão")),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('missions')
            .doc(missionId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  child: Image.network(
                    data['image'] ??
                        'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=60',
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                SizedBox(height: 16),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Center(
                          child: Text(
                            data['titulo'] ?? '',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 20,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  data['localizacao'] ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  data['municipio'] ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),

                buildSection(
                  "Principais",
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildMainInfo(
                        "Distância",
                        "${data['distancia_km']} km",
                        Icons.map,
                      ),
                      buildMainInfo(
                        "Tempo",
                        data['tempo_estimado'],
                        Icons.timer,
                      ),
                      buildMainInfo(
                        "Dificuldade",
                        data['dificuldade'] ?? "N/A",
                        Icons.directions_walk,
                      ),
                    ],
                  ),
                ),

                buildSection(
                  "Detalhes",
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildAltitudeInfo(
                        data['altitude_inicial'],
                        data['altitude_maxima'],
                        data['altitude_final'],
                      ),
                      SizedBox(height: 12),
                      buildDetailRow(
                        Icons.terrain,
                        "Ganho de altitude: ${data['ganho_altitude']} m",
                      ),
                    ],
                  ),
                ),

                if (data['descricao'] != null)
                  buildSection(
                    "Descrição",
                    Text(data['descricao_pt'], style: TextStyle(fontSize: 16)),
                  ),

                if (data['flora_relevante'] != null)
                  buildSection(
                    "Flora relevante",
                    buildTagRow(data['flora_relevante']),
                  ),

                if (data['atrativos'] != null)
                  buildSection("Atrativos", buildTagRow(data['atrativos'])),

                if (data['historico'] != null)
                  buildSection(
                    "Histórico",
                    Text(data['historico'], style: TextStyle(fontSize: 16)),
                  ),

                SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
