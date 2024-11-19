// ignore_for_file: constant_identifier_names

import 'package:flutter/cupertino.dart';

enum TabMenuCode {
  HOME,
  //MY_PAGE,
}

class ModelBottomNav {
  final TabMenuCode menuCode;
  final String title;
  final String selectedImagePath;
  final String unSelectedImagePath;
  final Widget activeIcon;
  final Widget inActiveIcon;
  final Widget page;

  ModelBottomNav(
      {required this.menuCode,
      required this.title,
      required this.selectedImagePath,
      required this.unSelectedImagePath,
      required this.activeIcon,
      required this.inActiveIcon,
      required this.page});
}
