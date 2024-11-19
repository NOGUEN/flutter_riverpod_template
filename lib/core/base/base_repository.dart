import 'package:dio/dio.dart';
import 'package:riverpod_template/core/domain/model/api_response.dart';

import '../build_config.dart';
import '../enum/request_type.dart';
import '../exception/exception_api_response.dart';
import '../exception/exception_api_response_parsing.dart';
import '../exception/handler/handler_dio_exception.dart';

abstract class BaseRepository {
  Dio dio;

  final logger = BuildConfig.instance.logger;

  BaseRepository({required this.dio});

  /// API 호출을 처리하고, 응답을 파싱하여 반환하는 메서드
  ///
  /// [requestType] 요청의 유형 (GET, POST, 등등)
  /// [endPoint] API의 엔드포인트 (예: '/users/{id}')
  /// [reqDto] 요청 시 전달할 데이터 (GET 요청의 경우 쿼리 파라미터, POST/PUT 요청의 경우 바디 데이터)
  /// [fromJsonT] 응답 데이터를 파싱하기 위한 함수
  /// [pathParams] 경로 매개변수로 사용할 값들 (URL 내 {} 부분을 대체)
  ///
  /// 이 메서드는 API 호출 시 발생할 수 있는 다양한 예외를 처리하며, 응답 데이터의 유효성을 확인하고
  /// 파싱하여 호출자에게 반환합니다.
  Future<dynamic> callApiWithErrorParser<T>({
    required RequestType requestType,
    required String endPoint,
    required Map<String, dynamic>? reqDto,
    required T Function(Map<String, dynamic>)? fromJsonT,
    Map<String, dynamic>? pathParams, // 추가된 부분
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      // Path parameters가 있다면 endPoint를 수정합니다.
      if (pathParams != null) {
        endPoint = endPoint.replaceAllMapped(RegExp(r"\{(\w+)\}"), (match) {
          return pathParams[match.group(1)]?.toString() ?? match.group(0)!;
        });
      }

      // 요청 실행
      Response response = await _performRequest(requestType, endPoint, reqDto,
          queryParams: queryParams, pathParams: pathParams);

      logger.i("api call response : ${response.data}");

      if (response.data['data'] == null) {
        ApiEmptyDataResponse apiResponse =
            ApiEmptyDataResponse.fromJson(response: response);

        if (apiResponse.code != "OK200000") {
          throw ExceptionApiResponse(
              msgForLog:
                  "[response.data['data'] == null] callApiWithErrorParser (apiResponse.status != 200 혹은 apiResponse.message가 ok가 아닙니다.) - apiResponse.message : ${apiResponse.message}",
              msgForUser:
                  apiResponse.message ?? '서버 오류가 발생하였습니다. 관리자에게 문의하세요.');
        }

        return;
      } else if (response.data['data'] is List) {
        ApiListResponse<T> apiResponse = ApiListResponse.fromJson(
            response: response,
            fromJsonT: (json) => fromJsonT!(json as Map<String, dynamic>));
        if (apiResponse.code != "OK200000") {
          throw ExceptionApiResponse(
              msgForLog:
                  "[response.data['data'] is List]callApiWithErrorParser (apiResponse.status != 200 혹은 apiResponse.message가 ok가 아닙니다.) - apiResponse.message : ${apiResponse.message}",
              msgForUser:
                  apiResponse.message ?? '서버 오류가 발생하였습니다. 관리자에게 문의하세요.');
        }

        if (apiResponse.data == null) {
          throw ExceptionApiResponse(
              msgForLog:
                  'callApiWithErrorParser() 실행 중 오류 - 응답 결과가 없습니다. \n apiResponse.data == null 상황 발생',
              msgForUser: '응답 결과가 없습니다.');
        }

        return apiResponse.data!;
      } else if (response.data['data'] is Map) {
        ApiResponse<T> apiResponse = ApiResponse.fromJson(
            response: response,
            fromJsonT: (json) => fromJsonT!(json as Map<String, dynamic>));

        if (apiResponse.code != "OK200000") {
          throw ExceptionApiResponse(
              msgForLog:
                  "[response.data['data'] is Map] callApiWithErrorParser (apiResponse.status != 200 혹은 apiResponse.message가 ok가 아닙니다.) - apiResponse.message : ${apiResponse.message}",
              msgForUser:
                  apiResponse.message ?? '서버 오류가 발생하였습니다. 관리자에게 문의하세요.');
        }

        if (apiResponse.data == null) {
          throw ExceptionApiResponse(
              msgForLog:
                  'callApiWithErrorParser() 실행 중 오류 - 응답 결과가 없습니다. \n apiResponse.data == null 상황 발생',
              msgForUser: '응답 결과가 없습니다.');
        }

        return apiResponse.data!;
      } else {
        throw Exception("Unsupported data type");
      }
    } on ExceptionApiResponseParsing catch (exception) {
      exception.log();
      rethrow;

      /// 이미 ApiResponse내부에서 예외처리 수행되었음
    } on DioException catch (dioException) {
      logger.i(dioException.message);
      throw HandlerDioException.handleDioError(dioException);
    } catch (e, s) {
      logger.e("BaseRepository Catch Error: ${e.toString()}");
      logger.e("BaseRepository StackTrace: ${s.toString()}");
      rethrow;
    }
  }

  /// HTTP 요청을 실제로 수행하는 메서드
  ///
  /// [requestType] 요청의 유형 (GET, POST, 등등)
  /// [endPoint] API의 엔드포인트 (경로 매개변수 치환 후의 최종 URL)
  /// [reqDto] 요청 시 전달할 데이터 (GET 요청의 경우 쿼리 파라미터, POST/PUT 요청의 경우 바디 데이터)
  /// [pathParams] 경로 매개변수로 사용할 값들 (URL 내 {} 부분을 대체)
  ///
  /// 이 메서드는 HTTP 요청을 보내기 전에 경로 매개변수를 처리하고, 각 요청 타입에 맞는 Dio 메서드를 호출하여 요청을 수행합니다.
  Future<Response> _performRequest(
    RequestType requestType,
    String endPoint,
    Map<String, dynamic>? reqDto, {
    Map<String, dynamic>? pathParams,
    Map<String, dynamic>? queryParams,
  }) async {
    if (pathParams != null) {
      endPoint = endPoint.replaceAllMapped(RegExp(r"\{(\w+)\}"), (match) {
        return pathParams[match.group(1)]?.toString() ?? match.group(0)!;
      });
    }

    switch (requestType) {
      case RequestType.GET:
        return await dio.get(endPoint, queryParameters: reqDto);
      case RequestType.POST:
        return await dio.post(endPoint,
            data: reqDto, queryParameters: queryParams);
      case RequestType.PUT:
        return await dio.put(endPoint, data: reqDto);
      case RequestType.DELETE:
        return await dio.delete(endPoint, queryParameters: reqDto);
      case RequestType.PATCH:
        return await dio.patch(endPoint, data: reqDto);
      default:
        throw Exception("Invalid request type");
    }
  }
}
