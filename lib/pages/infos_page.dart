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
  final List<Map<String, dynamic>> options = [
    {
      "title": "Contato de Guias",
      "icon": Icons.phone_iphone,
      "page": GuidesContact(),
    },
    {
      "title": "Eventos do Parque",
      "icon": Icons.celebration_rounded,
      "page": Events(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ...List.generate(options.length, (index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => options[index]["page"]),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      offset: Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      options[index]["icon"],
                      size: 30,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 16),
                    Expanded(child: Text(options[index]["title"])),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                      color: Colors.black.withOpacity(0.45),
                    ),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: 40),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 18,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                // HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _line(),
                    SizedBox(width: 10),
                    Text("Curiosidades",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        )),
                    SizedBox(width: 10),
                    _line(),
                  ],
                ),
                SizedBox(height: 22),
                PhraseCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _line() {
    return Container(
      height: 2,
      width: 35,
      color: Colors.black.withOpacity(0.15),
    );
  }
}
