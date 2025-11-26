import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:tcc_project/theme/app_colors.dart';

class Events extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final double cardHeight = MediaQuery.of(context).size.height * 0.85;
    final double cardWidth = MediaQuery.of(context).size.width * 0.90;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: AppColors.white),
        title: Text(
          "Eventos do Parque",
          style: TextStyle(fontSize: 18, color: AppColors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('events').orderBy('data').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return Center(
              child: Text(
                "Nenhum evento disponível.",
                style: TextStyle(color: AppColors.textPrimary),
              ),
            );

          final events = snapshot.data!.docs;
          final now = DateTime.now();
          List<Map<String, dynamic>> futureEvents = [];
          List<Map<String, dynamic>> pastEvents = [];

          for (var doc in events) {
            final event = doc.data() as Map<String, dynamic>;
            Timestamp? timestamp = event['data'];
            if (timestamp != null) {
              DateTime eventDate = timestamp.toDate();
              if (eventDate.isBefore(now)) {
                pastEvents.add(event);
              } else {
                futureEvents.add(event);
              }
            } else {
              futureEvents.add(event);
            }
          }

          final sortedEvents = [...futureEvents, ...pastEvents];

          return PageView.builder(
            controller: PageController(viewportFraction: 0.9),
            itemCount: sortedEvents.length,
            itemBuilder: (context, index) {
              final event = sortedEvents[index];
              final title = event['titulo'] ?? 'Evento sem título';
              final imageUrl =
                  event['imagemUrl'] ??
                  'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=60';

              Timestamp? timestamp = event['data'];
              String formattedDate = 'Data não informada';
              bool isPastEvent = false;

              if (timestamp != null) {
                DateTime dateTime = timestamp.toDate();
                formattedDate = DateFormat(
                  'dd/MM/yyyy\nHH:mm',
                ).format(dateTime);
                isPastEvent = dateTime.isBefore(now);
              }

              return Center(
                child: Container(
                  height: cardHeight,
                  width: cardWidth,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Stack(
                    children: [
                      Hero(
                        tag: 'event-$title',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.network(
                            imageUrl,
                            height: cardHeight,
                            width: cardWidth,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              AppColors.black.withOpacity(0.65),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: AppColors.black.withOpacity(0.4),
                                    offset: Offset(1, 1),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                color: AppColors.white.withOpacity(0.85),
                                fontSize: 18,
                                shadows: [
                                  Shadow(
                                    color: AppColors.black.withOpacity(0.4),
                                    offset: Offset(1, 1),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            if (!isPastEvent)
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EventDetailScreen(
                                        imageUrl: imageUrl,
                                        tag: 'event-$title',
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryStrong,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    "Ver mais",
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            if (isPastEvent)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.earthBrown.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  "Evento já ocorreu",
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
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
      ),
    );
  }
}

class EventDetailScreen extends StatelessWidget {
  final String imageUrl;
  final String tag;

  EventDetailScreen({required this.imageUrl, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Hero(
            tag: tag,
            child: InteractiveViewer(
              child: Image.network(imageUrl, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }
}
