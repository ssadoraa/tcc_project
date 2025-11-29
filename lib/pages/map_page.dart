import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:tcc_project/controller/map_controller.dart';
import 'package:tcc_project/model/attraction_dependence.dart';
import 'package:tcc_project/theme/app_colors_light.dart';

class MapPage extends StatefulWidget {
  MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final controller = MapController();

  final List<AttractionDependence> attractions = [
    AttractionDependence(
      id: '1',
      qrCode: '',
      titulo: 'Ponto 1',
      image: '',
      localizacao: 'Local A',
      municipio: 'Cidade X',
      tempoEstimado: '30 min',
      dificuldade: 'Fácil',
      descricao: 'Descrição do ponto 1',
      distanciaKm: 1.2,
      altitudeInicial: 100,
      altitudeMaxima: 150,
      altitudeFinal: 120,
      ganhoAltitude: 50,
      floraRelevante: ['Planta A', 'Planta B'],
      atrativos: ['Cachoeira', 'Mirante'],
      infraestrutura: ['Banheiro'],
      agua: true,
      condicaoTrilha: 'Boa',
      recomendacao: 'Use tênis',
      historico: 'História do local',
      latitude: -21.959261,
      longitude: -42.010313,
    ),
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void showFixedPinSheet(AttractionDependence attraction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: AppColorsLight.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    attraction.image.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: Image.network(
                              attraction.image,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColorsLight.border,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            child: Icon(
                              Icons.photo,
                              size: 100,
                              color: AppColorsLight.textSecondary,
                            ),
                          ),

                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            attraction.titulo,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColorsLight.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "${attraction.localizacao} - ${attraction.municipio}",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColorsLight.textSecondary,
                            ),
                          ),
                          SizedBox(height: 16),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _infoCard(
                                  Icons.map,
                                  "${attraction.distanciaKm} km",
                                  "Distância",
                                ),
                                SizedBox(width: 10),
                                _infoCard(
                                  Icons.timer,
                                  attraction.tempoEstimado,
                                  "Tempo",
                                ),
                                SizedBox(width: 10),
                                _infoCard(
                                  Icons.terrain,
                                  attraction.dificuldade,
                                  "Dificuldade",
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20),

                          _waterInfo(attraction.agua),

                          SizedBox(height: 20),

                          if (attraction.infraestrutura.isNotEmpty) ...[
                            Text("Infraestrutura", style: _sectionTitle()),
                            SizedBox(height: 4),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: attraction.infraestrutura
                                  .map((i) => _tag(i))
                                  .toList(),
                            ),
                            SizedBox(height: 16),
                          ],

                          if (attraction.recomendacao.isNotEmpty) ...[
                            Text("Recomendação", style: _sectionTitle()),
                            SizedBox(height: 8),
                            _recommendationTag(
                              recomendacao: false,
                              texto: attraction.recomendacao,
                            ),
                            SizedBox(height: 16),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _recommendationTag({required bool recomendacao, String? texto}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: recomendacao
            ? AppColorsLight.primaryStrong.withOpacity(0.15)
            : AppColorsLight.lightGreen.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            recomendacao ? Icons.explore : Icons.directions_walk,
            color: recomendacao
                ? AppColorsLight.primaryStrong
                : AppColorsLight.secondaryStrong,
            size: 20,
          ),
          SizedBox(width: 6),
          Text(
            recomendacao ? "Guia recomendado" : "Autônomo",
            style: TextStyle(
              color: recomendacao
                  ? AppColorsLight.primaryStrong
                  : AppColorsLight.secondaryStrong,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (texto != null) ...[
            SizedBox(width: 8),
            Flexible(
              child: Text(
                texto,
                style: TextStyle(
                  color: AppColorsLight.textPrimary,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _waterInfo(bool hasWater) {
    return Row(
      children: [
        Icon(
          hasWater ? Icons.water : Icons.water_outlined,
          color: hasWater
              ? AppColorsLight.primaryStrong
              : AppColorsLight.textSecondary,
          size: 20,
        ),
        SizedBox(width: 6),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: hasWater
                ? AppColorsLight.lightOrangeOpacity
                : AppColorsLight.border,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            hasWater ? "Tem água" : "Sem água",
            style: TextStyle(
              color: hasWater
                  ? AppColorsLight.primaryStrong
                  : AppColorsLight.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoCard(IconData icon, String value, String label) {
    return Container(
      width: 110,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColorsLight.lightOrangeOpacity,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColorsLight.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: AppColorsLight.primaryStrong),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColorsLight.textPrimary,
            ),
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: AppColorsLight.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _tag(String text) {
    return Chip(
      label: Text(text),
      backgroundColor: AppColorsLight.lightGreen,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  TextStyle _sectionTitle() {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColorsLight.textPrimary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapWidget(
        styleUri: MapboxStyles.MAPBOX_STREETS,
        onMapCreated: (map) async {
          await controller.initMap(
            map,
            attractionList: attractions,
            onTapAttraction: (attraction) {
              showFixedPinSheet(attraction);
            },
          );
        },
      ),
    );
  }
}
