import 'package:flutter/cupertino.dart';
import 'package:riverpod_template/core/dependencies/controller_di.dart';
import 'package:riverpod_template/presentation/route/main_route.dart';
import 'app_routes.dart';

abstract class AppPages {
  static final routes = <String, WidgetBuilder>{
    Routes.SPLASH: (context) =>
        MainRoute(controllerProvider: myControllerProvider),
  };
}
