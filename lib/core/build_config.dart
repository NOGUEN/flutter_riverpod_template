import 'package:logger/logger.dart';

import 'enum/flavor.dart';
import 'exception/exception_build_config_not_initialized.dart';

/*
* .env 파일로 설정을 관리하게 된다면 해당 .env를 read하여 앱 전역에서 사용할
* 설정 값들을 보유하여 런타임에 참조 가능하도록 함
*
* (현재 프로젝트에서는 .env파일로 관리하지 않으므로 initialize 함수 호출하여 멤버 변수 초기화 진행)
*/

class BuildConfig {
  // Singleton instance
  static final BuildConfig _instance = BuildConfig._internal();

  // Private constructor
  BuildConfig._internal([this._baseUrl = '']);

  // Singleton instance getter
  static BuildConfig get instance {
    // BuildConfig initialize 되었는지 검증
    if (_instance._baseUrl.isEmpty) {
      throw const ExceptionBuildConfigNotInitialized();
    }
    return _instance;
  }

  // BuildConfig내부 변수들

  late String _androidVersion;
  String get androidVersion => _androidVersion;

  late String _iosVersion;
  String get iosVersion => _iosVersion;

  late String _appTitle;
  String get appTitle => _appTitle;

  late String _baseUrl;
  String get baseUrl => _baseUrl;

  late String _accessTokenEndPoint;
  String get accessTokenEndPoint => _accessTokenEndPoint;

  late String _refreshTokenEndPoint;
  String get refreshTokenEndPoint => _refreshTokenEndPoint;

  late Flavor _flavor;
  Flavor get flavor => _flavor;

  late bool _setDeveloperValues;
  bool get setDeveloperValues => _setDeveloperValues;

  late Logger _logger;
  Logger get logger => _logger;

  late String _developerAccountEmail;
  String get developerAccountEmail => _developerAccountEmail;

  late String _developerAccountPss;
  String get developerAccountPss => _developerAccountPss;

  late double _basicDeviceWidth;
  double get basicDeviceWidth => _basicDeviceWidth;

  /// 디자이너가 figma에 작업할때 사용한 device 의 width

  late double _basicDeviceHeight;
  double get basicDeviceHeight => _basicDeviceHeight;

  /// 디자이너가 figma에 작업할때 사용한 device 의 height

  late String _testPinNumber;
  String get testPinNumber => _testPinNumber;

  // Static method to initialize the configuration
  static Future<void> initialize({
    required String androidVersion,
    required String iosVersion,
    required String appTitle,
    required String baseUrl,
    required Flavor flavor,
    required bool setDeveloperValues,
    required String developerAccountEmail,
    required String developerAccountPss,
    required double basicDeviceWidth,
    required double basicDeviceHeight,
    required String accessTokenEndPoint,
    required String refreshTokenEndPoint,
    required String testPinNumber,
  }) async {
    _instance._initialize(
      androidVersion: androidVersion,
      iosVersion: iosVersion,
      appTitle: appTitle,
      baseUrl: baseUrl,
      flavor: flavor,
      setDeveloperValues: setDeveloperValues,
      developerAccountEmail: developerAccountEmail,
      developerAccountPss: developerAccountPss,
      basicDeviceWidth: basicDeviceWidth,
      basicDeviceHeight: basicDeviceHeight,
      accessTokenEndPoint: accessTokenEndPoint,
      refreshTokenEndPoint: refreshTokenEndPoint,
      testPinNumber: testPinNumber,
    );
  }

  // Initialize method to set the base URL
  void _initialize(
      {required String androidVersion,
      required String iosVersion,
      required String appTitle,
      required String baseUrl,
      required Flavor flavor,
      required bool setDeveloperValues,
      required String developerAccountEmail,
      required String developerAccountPss,
      required double basicDeviceWidth,
      required double basicDeviceHeight,
      required String accessTokenEndPoint,
      required String refreshTokenEndPoint,
      required String testPinNumber}) {
    _androidVersion = androidVersion;
    _iosVersion = iosVersion;
    _appTitle = appTitle;
    _baseUrl = baseUrl;
    _flavor = flavor;
    _setDeveloperValues = setDeveloperValues;
    _logger = (flavor == Flavor.pro) ? EmptyLogger() : Logger();
    _developerAccountEmail = developerAccountEmail;
    _developerAccountPss = developerAccountPss;
    _basicDeviceWidth = basicDeviceWidth;
    _basicDeviceHeight = basicDeviceHeight;
    _accessTokenEndPoint = accessTokenEndPoint;
    _refreshTokenEndPoint = refreshTokenEndPoint;
    _testPinNumber = testPinNumber;
  }
}

// product 환경에서 사용할 Logger <--- product 환경에서는 로그가 출력되면 안됨
class EmptyLogger implements Logger {
  @override
  Future<void> close() async {
    return;
  }

  @override
  void d(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {}

  @override
  void e(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {}

  @override
  void f(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {}

  @override
  void i(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {}

  @override
  Future<void> get init => throw UnimplementedError();

  @override
  bool isClosed() => true;

  @override
  void log(Level level, message,
      {DateTime? time, Object? error, StackTrace? stackTrace}) {}

  @override
  void t(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {}

  @override
  void v(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {}

  @override
  void w(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {}

  @override
  void wtf(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {}
}
