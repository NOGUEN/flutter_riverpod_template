import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../build_config.dart';
import '../enum/route_arg_tag.dart';

class RouteManager extends NavigatorObserver {
  RouteManager._internal() {
    _navigatorKey = GlobalKey<NavigatorState>();
  }
  static final RouteManager _instance = RouteManager._internal();
  static RouteManager get instance => _instance;

  late GlobalKey<NavigatorState> _navigatorKey;
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
  BuildContext get appContext => _navigatorKey.currentContext!;

  final List<String> _navigationStack = [];
  List<String> get navigationStack => List.unmodifiable(_navigationStack);
  String get currentRoute => navigationStack.last;

  final Map<RouteArgTAG, dynamic> _params = {};

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    BuildConfig.instance.logger.i("RouteManager - didPush called!!");
    _updateNavigationStack(route.settings);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    BuildConfig.instance.logger.i("RouteManager - didPop called!!");
    if (previousRoute != null) {
      _updateNavigationStack(route.settings, isPop: true);
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    BuildConfig.instance.logger.i("RouteManager - didRemove called!!");
    if (previousRoute != null) {
      _updateNavigationStack(route.settings, isRemove: true);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    BuildConfig.instance.logger.i("Did Replace!!!");
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _updateNavigationStack(newRoute.settings, isReplace: true);
    }
  }

  void _updateNavigationStack(RouteSettings? settings,
      {bool isPop = false, bool isRemove = false, bool isReplace = false}) {
    if (settings != null && (settings.name ?? "").isNotEmpty) {
      if (isPop || isRemove) {
        _navigationStack.removeLast();
      }
      if (isReplace) {
        _navigationStack.removeLast();
        _navigationStack.add(settings.name!);
      }
      if (!isPop && !isRemove && !isReplace) {
        _navigationStack.add(settings.name!);
      }
    }
    BuildConfig.instance.logger
        .i("current navigation stack - ${_navigationStack}");
  }

  replaceNamed({
    required BuildContext? context,
    required String routes,
    dynamic arg,

    /// 단일로 보낼때
    RouteArgTAG? argTAG,

    /// 단일로 보낼때
    Map<RouteArgTAG, dynamic>? argMap,

    /// 여러개 보낼때
  }) {
    BuildConfig.instance.logger.i("routing to \${routes}");

    /// 단일 param요청시
    if (arg != null && argTAG != null) {
      BuildConfig.instance.logger.i("argument is \${arg}");
      BuildConfig.instance.logger.i("argumentTAG is \${argTAG}");
      _params[argTAG] = arg;
    } else if (argMap != null) {
      /// 여러개의 param요청시

      argMap.forEach((key, value) {
        _params[key] = value;
      });
    }

    if (context == null) {
      _navigatorKey.currentState?.pushReplacementNamed(routes);
    } else {
      Navigator.pushReplacementNamed(context, routes);
    }
  }

  /*
  *
  * parameter전달시 주의해야합니다!
  * 단일 파람 혹은 여러개의 파람 둘중 하나만 보내도록해야한다.
  *
  */
  pushNamed({
    required BuildContext? context,
    required String routes,
    dynamic arg,

    /// 단일로 보낼때
    RouteArgTAG? argTAG,

    /// 단일로 보낼때
    Map<RouteArgTAG, dynamic>? argMap,

    /// 여러개 보낼때
    bool removeOthers = false,
  }) {
    BuildConfig.instance.logger.i("routing to \${routes}");

    /// 단일 param요청시
    if (arg != null && argTAG != null) {
      BuildConfig.instance.logger.i("argument is \${arg}");
      BuildConfig.instance.logger.i("argumentTAG is \${argTAG}");
      _params[argTAG] = arg;
    } else if (argMap != null) {
      /// 여러개의 param요청시

      argMap.forEach((key, value) {
        _params[key] = value;
      });
    }

    if (context == null) {
      if (removeOthers) {
        _navigationStack.clear();
        _navigatorKey.currentState
            ?.pushNamedAndRemoveUntil(routes, (Route<dynamic> route) => false);
      } else {
        _navigatorKey.currentState?.pushNamed(routes);
      }
    } else {
      if (removeOthers) {
        _navigationStack.clear();
        Navigator.pushNamedAndRemoveUntil(
            context, routes, (Route<dynamic> route) => false);
      } else {
        Navigator.pushNamed(context, routes);
      }
    }
  }

  pop({required BuildContext? context}) {
    if (context != null) {
      Navigator.of(context).pop();
    } else {
      _navigatorKey.currentState?.pop();
    }
  }

  popUntil({required BuildContext? context, required String untilRoute}) {
    if (context != null) {
      Navigator.of(context).popUntil((route) {
        return route.settings.name == untilRoute;
      });
    } else {
      _navigatorKey.currentState?.popUntil((route) {
        return route.settings.name == untilRoute;
      });
    }
  }

  /// 유효하지 않은 BuildContext를 사용하여 Navigator를 사용해 popUntil을 시도할 경우 null check Error가 발생할 가능성이 존재
  /// -> 이에 앱 전역에서 스택의 FirstPage를 제외한 나머지 페이지를 제거하는 메서드를 추가
  popUntilFirst() {
    return _navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }

  dynamic getArgument({required RouteArgTAG argTAG}) {
    dynamic arg = _params[argTAG];
    _params[argTAG] = null;
    return arg;
  }

  terminateApp() => exit(0);
}
