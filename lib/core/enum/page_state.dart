// 앱내 페이지의 상태 체크만 하므로 fromString, 등의 메서드는 따로 구현하지 않습니다.
// ignore_for_file: constant_identifier_names

enum PageState {
  DEFAULT,
  LOADING,
  SUCCESS,
  FAILED,
}
