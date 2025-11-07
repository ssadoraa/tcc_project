import 'package:flutter/material.dart';
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
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
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
                    MaterialPageRoute(builder: (context) => GuidesContact()),
                  );
                } else if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Events()),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
