import 'package:flutter/material.dart';
import 'package:tcc_project/pages/config_page.dart';
import 'package:tcc_project/pages/infos_page.dart';
import 'package:tcc_project/pages/map_page.dart';
import 'package:tcc_project/pages/mission_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int itemSelecionado = 0;

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return MapPage();
      case 1:
        return MissionPage();
      case 2:
        return InfosPage();
      case 3:
        return ConfigPage();
      default:
        return MapPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DesenGo')),
      body: _getPage(itemSelecionado),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: itemSelecionado,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_rounded), label: 'Missões'),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'Infos'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Config'),
        ],
        onTap: (index) {
          setState(() {
            itemSelecionado = index;
          });
        },
      ),
    );
  }
}
