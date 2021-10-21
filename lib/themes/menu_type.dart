import 'package:flutter/material.dart';

class MenuType {
  String typeTitle;
  IconData icon;
  MenuType({this.icon, this.typeTitle});
}

List<MenuType> menuTypes = [
  new MenuType(icon: Icons.list, typeTitle: MenuTitles.List),
  new MenuType(icon: Icons.grid_on, typeTitle: MenuTitles.Grid),
];

class MenuTitles {
  static const String List = 'list';
  static const String Grid = 'grid';
}