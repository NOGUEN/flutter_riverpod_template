// Flavor는 앱 내에서만 체크 용도로 사용하므로 fromString 등 구현하지 않습니다.

enum Flavor {
  prototype,

  /// 와이어 프레임 개발 단계
  dev,

  /// 개발
  stg,

  /// 테스트 환경 (Staging)
  pro

  /// 운영 환경 (Production)
}
