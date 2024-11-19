import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_template/core/enum/flavor.dart';
import 'package:riverpod_template/core/manager/route_manager.dart';

import 'core/build_config.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp]); //세로고정

      PlatformDispatcher.instance.onError = (error, stack) {
        //FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      await BuildConfig.initialize(
        androidVersion: "1.0.0",
        iosVersion: "1.0.0",
        appTitle: "Riverpod Template",
        baseUrl: "프로젝트 baseURL",
        flavor: Flavor.dev,
        setDeveloperValues: true,
        developerAccountEmail: "개발자 테스트 이메일",
        developerAccountPss: "개발자 테스트 비밀번호",
        basicDeviceWidth: 375,
        basicDeviceHeight: 812,
        accessTokenEndPoint: "/login",
        refreshTokenEndPoint: "/refresh",
        testPinNumber: "0000",
      );

      //await RemoteConfigManager.instance.initialize();

      runApp(ProviderScope(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          ),
          navigatorKey: RouteManager.instance.navigatorKey,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ko', 'KR'),
          ],
          themeMode: ThemeMode.light,
          theme:
              ThemeData(primarySwatch: Colors.blue, fontFamily: 'NotoSansKR'),
          routes: AppPages.routes,
          navigatorObservers: [RouteManager.instance],
          initialRoute: Routes.SPLASH,
        ),
      ));
    },
    (error, stack) {
      /// 이곳에 앱 전역에서 오류 발생시 어떻게 대처할것인지 혹은 로깅할것인지 작성
    },
  );
}
