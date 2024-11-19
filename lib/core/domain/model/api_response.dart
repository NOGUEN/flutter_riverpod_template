import 'package:dio/dio.dart';
import 'package:riverpod_template/core/build_config.dart';
import 'package:riverpod_template/core/exception/exception_api_response_parsing.dart';

class ApiEmptyDataResponse {
  String? code;

  /// 서버로 부터 받은 메시지
  String? message;

  /// 서버로부터 받은메시지 혹은 내부에서 발생한 오류 메시지
  ApiEmptyDataResponse({this.code, this.message});

  factory ApiEmptyDataResponse.fromJson({required Response response}) {
    String? code;
    String? message;

    try {
      code = response.data['code'];
      message = response.data['message'];
    } catch (e, s) {
      throw ExceptionApiResponseParsing(
          msgForUser: "네트워크 응답 결과를 읽어오지 못했습니다. 관리자에게 문의하세요.",
          msgForLog: "ApiParsingError - ${e.toString()}",
          stackTrace: s);
    }

    return ApiEmptyDataResponse(
      code: code,
      message: message,
    );
  }
}

class ApiResponse<T> {
  T? data;

  /// 서버로 부터 응답받을 데이터
  String? code;

  /// 서버로 부터 받은 메시지
  String? message;

  ApiResponse({this.data, this.code, this.message});

  factory ApiResponse.fromJson({
    required Response response,
    required T Function(Object? json) fromJsonT,
  }) {
    Map<String, dynamic> json = response.data;

    T? data;
    String? code;
    String? message;

    try {
      data = fromJsonT(json['data']);
      code = response.data['code'];
      message = response.data['message'];
      BuildConfig.instance.logger.i(data);
    } catch (e, s) {
      throw ExceptionApiResponseParsing(
          msgForUser: "네트워크 응답 결과를 읽어오지 못했습니다. 관리자에게 문의하세요.",
          msgForLog: "ApiParsingError - ${e.toString()}",
          stackTrace: s);
    }

    return ApiResponse(
      data: data,
      code: code,
      message: message,
    );
  }
}

class ApiListResponse<T> {
  List<T>? data;

  /// 서버로 부터 응답받을 데이터
  String? code;

  /// 서버로 부터 받은 메시지
  String? message;

  ApiListResponse({this.data, this.code, this.message});

  factory ApiListResponse.fromJson({
    required Response response,
    required T Function(Object? json) fromJsonT,
  }) {
    Map<String, dynamic> json = response.data;

    List<T>? data;
    String? code;
    String? message;

    try {
      if (json['data'] is List) {
        List<dynamic> jsonDataList = json['data'];
        data = jsonDataList.map((itemJson) => fromJsonT(itemJson)).toList();
      }
      code = response.data['code'];
      message = response.data['message'];
    } catch (e, s) {
      throw ExceptionApiResponseParsing(
          msgForUser: "네트워크 응답 결과를 읽어오지 못했습니다. 관리자에게 문의하세요.",
          msgForLog: "ApiParsingError - ${e.toString()}",
          stackTrace: s);
    }

    return ApiListResponse(
      data: data,
      code: code,
      message: message,
    );
  }
}
