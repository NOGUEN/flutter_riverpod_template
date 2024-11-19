import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../exception_custom.dart';

abstract class HandlerDioException {
  static ExceptionCustom handleDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.cancel:
        return ExceptionCustom(
            msgForUser: "네트워크 연결상태를 확인하세요",
            msgForLog: dioException.message ?? "",
            stackTrace: dioException.stackTrace);
      case DioExceptionType.connectionTimeout:
        return ExceptionCustom(
            msgForUser: "네트워크 연결상태를 확인하세요",
            msgForLog: dioException.message ?? "",
            stackTrace: dioException.stackTrace);
      case DioExceptionType.unknown:

        /// Todo - crashlytics보고 해야함
        return ExceptionCustom(
            msgForUser: "(unknown) 네트워크 오류가 발생했습니다. 관리자에게 문의하세요 ",
            msgForLog: dioException.message ?? dioException.message ?? "",
            stackTrace: dioException.stackTrace);
      case DioExceptionType.receiveTimeout:
        return ExceptionCustom(
            msgForUser: "네트워크 연결상태를 확인하세요",
            msgForLog: dioException.message ?? "",
            stackTrace: dioException.stackTrace);
      case DioExceptionType.sendTimeout:
        return ExceptionCustom(
            msgForUser: "네트워크 연결상태를 확인하세요",
            msgForLog: dioException.message ?? "",
            stackTrace: dioException.stackTrace);
      case DioExceptionType.badResponse:
        String message = '잘못된 요청입니다. 관리자에게 문의하세요';

        if (dioException.response?.statusCode == 429) {
          message = '비 정상 적인 요청이 감지되었습니다. 잠시 후 다시 시도해주세요.';
        } else if (dioException.response?.data['message'] != null) {
          message = dioException.response!.data['message'];
        } else if (dioException.message != null) {
          message = dioException.message!;
        } else if (dioException.response?.statusMessage != null) {
          message = dioException.response!.statusMessage!;
        }
        return ExceptionCustom(
            msgForUser: message,
            msgForLog: dioException.message ?? "",
            stackTrace: dioException.stackTrace);
      default:
        debugPrint("dioException - ${dioException.message}");
        return ExceptionCustom(
            msgForUser: dioException.response?.statusMessage ??
                'Bad Request 관리자에게 문의하세요',
            msgForLog: dioException.message ?? "",
            stackTrace: dioException.stackTrace);
    }
  }
}
