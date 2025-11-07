import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Events extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final double cardHeight = MediaQuery.of(context).size.height * 0.85;
    final double cardWidth = MediaQuery.of(context).size.width * 0.90;

    return Scaffold(
      appBar: AppBar(title: Text("Eventos do Parque", style: TextStyle(fontSize: 18))),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('events').orderBy('data').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return Center(child: Text("Nenhum evento disponível."));

          final events = snapshot.data!.docs;

          return PageView.builder(
            controller: PageController(viewportFraction: 0.9),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index].data() as Map<String, dynamic>;
              final title = event['titulo'] ?? 'Evento sem título';

              Timestamp? timestamp = event['data'];
              String formattedDate = 'Data não informada';
              if (timestamp != null) {
                DateTime dateTime = timestamp.toDate();
                formattedDate = DateFormat('dd/MM/yyyy\nHH:mm').format(dateTime);
              }

              final imageUrl = event['imagemUrl'] ??
                  'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=60';

              return Center(
                child: Container(
                  height: cardHeight,
                  width: cardWidth,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Stack(
                    children: [
                      Hero(
                        tag: 'event-${title}',
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
                            colors: [Colors.black54, Colors.transparent],
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
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EventDetailScreen(
                                      imageUrl: imageUrl,
                                      tag: 'event-${title}',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 124, 124, 124),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  "Ver mais",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
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
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Hero(
            tag: tag,
            child: InteractiveViewer(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
