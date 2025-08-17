import 'package:flutter/material.dart';

class InfosPage extends StatefulWidget {
  InfosPage({Key? key}) : super(key: key);

  @override
  _InfosPageState createState() => _InfosPageState();
}

class _InfosPageState extends State<InfosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Infos Page')),
    );
  }
}
