class ExceptionBuildConfigNotInitialized implements Exception {
  final String message;

  const ExceptionBuildConfigNotInitialized(
      {this.message = "BuildConfig가 초기화 되지 않았습니다. initialize를 먼저 호출해주세요."});

  @override
  String toString() => "ExceptionBuildConfigNotInitialized, message: $message";
}
