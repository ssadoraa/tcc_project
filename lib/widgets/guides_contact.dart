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
        title: Text("Contatos de Guias", style: TextStyle(fontSize: 18))
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('guides').orderBy('nome').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          }

          final data = snapshot.data!.docs;
          if (data.isEmpty) {
            return Center(child: Text("Nenhum guia encontrado."));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final guide = data[index].data() as Map<String, dynamic>;

              return Container(
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
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
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: Text(
                              (guide['nome'] ?? 'G')[0].toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.primary,
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
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "CAD: ${guide['cad']}",
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "${guide['cidade'] ?? ''} - ${guide['estado'] ?? ''}",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Divider(
                        color: AppColors.primary.withOpacity(0.3),
                        thickness: 1,
                      ),
                      SizedBox(height: 5),
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.background,
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
                                  Icon(Icons.email_outlined, size: 18),
                                  SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      guide['email'] ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
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
                                        Icon(Icons.phone_outlined, size: 18),
                                        SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            guide['telefone'] ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              decoration: TextDecoration.underline,
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
                                    _launch(Uri.parse('https://wa.me/$telefone'));
                                  },
                                  icon: Image.asset('assets/images/whatsapp.png',
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
