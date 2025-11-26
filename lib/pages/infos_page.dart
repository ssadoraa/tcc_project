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
      "title": "Contato de Guias do Parque",
      "icon": Icons.phone_iphone,
      "page": GuidesContact(),
      "color": AppColors.lightGreen,
    },
    {
      "title": "Eventos do Parque",
      "icon": Icons.celebration_rounded,
      "page": Events(),
      "color": AppColors.lightOrangeOpacity,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (MediaQuery.of(context).size.width / 180)
                  .floor()
                  .clamp(1, 2),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => option["page"]),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.textPrimary.withOpacity(0.15),
                        offset: Offset(0, 6),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.white,
                        child: Icon(
                          option["icon"],
                          size: 32,
                          color: AppColors.primaryStrong,
                        ),
                      ),
                      SizedBox(height: 12),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          option["title"],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 32),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.secondary.withOpacity(0.8),
                  AppColors.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textPrimary.withOpacity(0.12),
                  blurRadius: 18,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _line(),
                    SizedBox(width: 10),
                    Text(
                      "Curiosidades",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
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
      decoration: BoxDecoration(
        color: AppColors.primaryStrong,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
