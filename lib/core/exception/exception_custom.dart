import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../build_config.dart';

/*
*
* ExceptionCustom으로 예외를 던지는 것은 모두 앱의 분기처리 혹은 비즈니스 로직에 영향을 주지않고
* 모두 Toast Message를 띄울것을 약속한다.
*
*/

class ExceptionCustom implements Exception {
  final String msgForUser;
  final String msgForLog;
  final StackTrace? stackTrace;
  ExceptionCustom({
    this.msgForUser = "",
    this.msgForLog = "",
    this.stackTrace,
  }) {
    log();
  }

  void log() {
    BuildConfig.instance.logger.e("$runtimeType - $msgForLog");
    BuildConfig.instance.logger.e("$runtimeType - $stackTrace");
    debugPrintStack();
  }

  void showToastMessage() => Fluttertoast.showToast(msg: msgForUser);
}
