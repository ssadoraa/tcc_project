import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final int missionId;

  const DetailsPage({Key? key, required this.missionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mission = missionId.firstWhere((m) => m['id'] == missionId);

    return Scaffold(
      appBar: AppBar(title: Text(mission['title'])),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(mission['image'], fit: BoxFit.cover, height: 250),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                mission['description'],
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on int {
  firstWhere(bool Function(dynamic m) param0) {}
}
