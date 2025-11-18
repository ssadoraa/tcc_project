import 'package:flutter/material.dart';
import 'package:tcc_project/theme/app_colors.dart';
import 'package:tcc_project/widgets/phrase_card.dart';
import 'package:tcc_project/widgets/events.dart';
import 'package:tcc_project/widgets/guides_contact.dart';

class InfosPage extends StatefulWidget {
  InfosPage({Key? key}) : super(key: key);

  @override
  _InfosPageState createState() => _InfosPageState();
}

class _InfosPageState extends State<InfosPage> {
  final List<String> items = ["Contato de Guias", "Eventos do Parque"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ...List.generate(items.length, (index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(items[index]),
                leading: Icon(Icons.info),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  if (index == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => GuidesContact()),
                    );
                  } else if (index == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Events()),
                    );
                  }
                },
              ),
            );
          }),

          SizedBox(height: 50),
          Card(
            color: AppColors.secondary,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: Colors.black.withOpacity(0.05),
                width: 1.2,
              ),
            ),
            shadowColor: Colors.black.withOpacity(0.15),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Curiosidades",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),

                  SizedBox(height: 16),
                  PhraseCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}