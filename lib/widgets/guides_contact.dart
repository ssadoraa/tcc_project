import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_project/model/guide.dart';
import '../controller/guide_controller.dart';
import '../theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class GuidesContact extends StatelessWidget {
  GuidesContact({Key? key}) : super(key: key);

  Future<void> _launch(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GuideController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: AppColors.white),
        title: Text(
          "Contatos de Guias",
          style: TextStyle(color: AppColors.white, fontSize: 18),
        ),
      ),
      body: StreamBuilder(
        stream: context.read<GuideController>().service.getGuides(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );

          final guides = snapshot.data!;
          controller.loadGuides(guides);

          if (guides.isEmpty)
            return Center(
              child: Text(
                "Nenhum guia encontrado.",
                style: TextStyle(color: AppColors.textPrimary),
              ),
            );

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: guides.length,
            itemBuilder: (context, index) {
              final guide = guides[index];
              return GuideCard(guide: guide, launch: _launch);
            },
          );
        },
      ),
    );
  }
}

class GuideCard extends StatelessWidget {
  final Guide guide;
  final Future<void> Function(Uri uri) launch;

  GuideCard({required this.guide, required this.launch});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.lightOrangeOpacity,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.background,
                  child: Text(
                    guide.nome[0].toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.secondaryStrong,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        guide.nome,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.secondaryStrong,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "CAD: ${guide.cad}",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${guide.cidade} - ${guide.estado}",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(color: AppColors.lightGreen, thickness: 2),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.background.withOpacity(0.95),
                border: Border.all(color: AppColors.primary.withOpacity(0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () =>
                        launch(Uri(scheme: 'mailto', path: guide.email)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: 18,
                          color: AppColors.secondaryStrong,
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            guide.email,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              launch(Uri(scheme: 'tel', path: guide.telefone)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.phone_outlined,
                                size: 18,
                                color: AppColors.secondaryStrong,
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  guide.telefone,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: "Abrir no WhatsApp",
                        onPressed: () {
                          final telefone = guide.telefone.replaceAll(
                            RegExp(r'[^0-9]'),
                            '',
                          );
                          launch(Uri.parse('https://wa.me/$telefone'));
                        },
                        icon: Image.asset(
                          'assets/images/whatsapp.png',
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
