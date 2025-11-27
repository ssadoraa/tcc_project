import 'package:flutter/material.dart';
import 'package:tcc_project/controller/attraction_controller.dart';
import 'package:tcc_project/model/attraction_dependence.dart';
import 'package:tcc_project/services/attraction_service.dart';
import 'package:tcc_project/theme/app_colors.dart';

class DetailsPage extends StatefulWidget {
  final String attractionId;

  DetailsPage({Key? key, required this.attractionId}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late final AttractionController controller;
  late final Future<AttractionDependence> attractionFuture;

  @override
  void initState() {
    super.initState();
    controller = AttractionController(AttractionService());
    attractionFuture = controller.getAttractionDependence(widget.attractionId);
  }

  Widget buildSection(String title, Widget child) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryStrong,
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightGreen.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget buildMainInfo(String label, String value, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.15),
          radius: 28,
          child: Icon(icon, size: 28, color: AppColors.primary),
        ),
        SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget buildAltitudeInfo(int inicial, int maxima, int finalAlt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildAltitudeColumn(Icons.arrow_upward, "Inicial", inicial),
        buildAltitudeColumn(Icons.terrain, "Máxima", maxima),
        buildAltitudeColumn(Icons.arrow_downward, "Final", finalAlt),
      ],
    );
  }

  Widget buildAltitudeColumn(IconData icon, String label, int value) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary),
        SizedBox(height: 4),
        Text(
          "$value m",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
            ),
          ),
        ],
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
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.secondaryStrong,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                item.toString(),
                style: TextStyle(fontSize: 14, color: AppColors.textThird),
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryStrong,
        iconTheme: IconThemeData(color: AppColors.textThird),
        title: Text(
          "Detalhes do Ponto",
          style: TextStyle(fontSize: 18, color: AppColors.textThird),
        ),
      ),
      body: FutureBuilder<AttractionDependence>(
        future: attractionFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Erro ao carregar a atração: ${snapshot.error}"),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primaryStrong),
            );
          }

          final a = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  child: Stack(
                    children: [
                      Image.network(
                        a.image,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=60',
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.black.withOpacity(0.15),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.lightOrangeOpacity,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textPrimary.withOpacity(0.1),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            a.titulo,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryStrong,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 25,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    a.localizacao,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    a.municipio,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                buildSection(
                  "Principais Informações",
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildMainInfo(
                        "Distância",
                        "${a.distanciaKm} km",
                        Icons.map,
                      ),
                      buildMainInfo("Tempo", a.tempoEstimado, Icons.timer),
                      buildMainInfo(
                        "Dificuldade",
                        a.dificuldade,
                        Icons.directions_walk,
                      ),
                    ],
                  ),
                ),
                buildSection(
                  "Detalhes de Altitude",
                  Column(
                    children: [
                      buildAltitudeInfo(
                        a.altitudeInicial,
                        a.altitudeMaxima,
                        a.altitudeFinal,
                      ),
                      SizedBox(height: 12),
                      buildDetailRow(
                        Icons.show_chart,
                        "Ganho de altitude: ${a.ganhoAltitude} m",
                      ),
                    ],
                  ),
                ),
                if (a.descricao.isNotEmpty)
                  buildSection(
                    "Descrição",
                    Text(a.descricao, style: TextStyle(fontSize: 16)),
                  ),
                if (a.floraRelevante.isNotEmpty || a.atrativos.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 16,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (a.floraRelevante.isNotEmpty)
                          Expanded(
                            child: buildSection(
                              "Flora",
                              buildTagRow(a.floraRelevante),
                            ),
                          ),
                        SizedBox(width: 16),
                        if (a.atrativos.isNotEmpty)
                          Expanded(
                            child: buildSection(
                              "Atrativos",
                              buildTagRow(a.atrativos),
                            ),
                          ),
                      ],
                    ),
                  ),
                if (a.historico.isNotEmpty)
                  buildSection(
                    "Curiosidade Histórica",
                    Text(a.historico, style: TextStyle(fontSize: 16)),
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
