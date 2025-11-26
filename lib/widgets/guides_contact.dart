import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tcc_project/theme/app_colors.dart';

class GuidesContact extends StatelessWidget {
  GuidesContact({Key? key}) : super(key: key);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _launch(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: AppColors.white),
        title: Text(
          "Contatos de Guias",
          style: TextStyle(fontSize: 18, color: AppColors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('guides').orderBy('nome').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Erro: ${snapshot.error}",
                style: TextStyle(color: AppColors.textPrimary),
              ),
            );
          }

          final data = snapshot.data!.docs;
          if (data.isEmpty) {
            return Center(
              child: Text(
                "Nenhum guia encontrado.",
                style: TextStyle(color: AppColors.textPrimary),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final guide = data[index].data() as Map<String, dynamic>;

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
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.15),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.background,
                            child: Text(
                              (guide['nome'] ?? 'G')[0].toUpperCase(),
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
                                  guide['nome'] ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppColors.secondaryStrong,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "CAD: ${guide['cad']}",
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "${guide['cidade'] ?? ''} - ${guide['estado'] ?? ''}",
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
                      Divider(
                        color: AppColors.lightGreen,
                        thickness: 1,
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.background.withOpacity(0.95),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.15),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => _launch(
                                Uri(scheme: 'mailto', path: guide['email']),
                              ),
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
                                      guide['email'] ?? '',
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
                                    onTap: () => _launch(
                                      Uri(
                                        scheme: 'tel',
                                        path: guide['telefone'],
                                      ),
                                    ),
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
                                            guide['telefone'] ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
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
                                    final telefone = (guide['telefone'] ?? "")
                                        .replaceAll(RegExp(r'[^0-9]'), '');
                                    _launch(
                                      Uri.parse('https://wa.me/$telefone'),
                                    );
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
            },
          );
        },
      ),
    );
  }
}
