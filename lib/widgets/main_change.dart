import 'package:flutter/material.dart';
import 'package:tcc_project/pages/attractions_page.dart';
import 'package:tcc_project/pages/setting_page.dart';
import 'package:tcc_project/pages/infos_page.dart';
import 'package:tcc_project/pages/map_page.dart';
import 'package:tcc_project/theme/app_colors.dart';

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
        return AttractionPage();
      case 2:
        return InfosPage();
      case 3:
        return SettingPage();
      default:
        return MapPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(85.0),
        child: AppBar(
          title: Padding(
            padding: EdgeInsets.only(top: 22.0),
            child: Text(
              'DesenGo',
              style: TextStyle(
                fontSize: 23,
                color: AppColors.primary(context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: AppColors.secondaryStrong(context),
          elevation: 4,
        ),
      ),
      body: _getPage(itemSelecionado),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.earthBrown(context).withAlpha(250),
        currentIndex: itemSelecionado,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.white(context),
        unselectedItemColor: AppColors.primary(context),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        onTap: (index) {
          setState(() {
            itemSelecionado = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Pontos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Infos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Config'),
        ],
      ),
    );
  }
}
