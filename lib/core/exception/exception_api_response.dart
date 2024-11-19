import 'package:riverpod_template/core/exception/exception_custom.dart';

class ExceptionApiResponse extends ExceptionCustom {
  ExceptionApiResponse({super.msgForLog, super.msgForUser, super.stackTrace})
      : super();
}
