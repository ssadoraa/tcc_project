import 'package:flutter/material.dart';
import 'package:tcc_project/pages/details_page.dart';

class MissionPage extends StatefulWidget {
  MissionPage({Key? key}) : super(key: key);

  @override
  _MissionPageState createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  final List<Map<String, dynamic>> missions = List.generate(12,
    (index) => {
      "id": index + 1,
      "image": "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=60",
      "title": "Missão ${index + 1}",
      "description": "Descrição detalhada da missão ${index + 1}. Aqui você pode colocar informações mais completas.",
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mission Page')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double cardWidth = 150;
          int crossAxisCount = (constraints.maxWidth / cardWidth).floor();
          if (crossAxisCount < 2) crossAxisCount = 2;

          return GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: missions.length,
            itemBuilder: (context, index) {
              final mission = missions[index];
              return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(missionId: mission['id']),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            mission["image"]!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text(
                          mission["title"]!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          mission["description"]!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ação do botão
        },
        child: Icon(Icons.add),
      ),
    );
  }
}