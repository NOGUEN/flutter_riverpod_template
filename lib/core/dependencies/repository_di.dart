import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_template/core/data/repositories/repository_common_impl.dart';
import 'package:riverpod_template/core/domain/repositories/repository_common.dart';
import 'package:riverpod_template/network/dio_injector.dart';

import '../build_config.dart';

final repositoryCommonProvider = Provider<RepositoryCommon>((ref) {
  Dio dio = DioInjector.createDioWithToken();

  String baseUrl = BuildConfig.instance.baseUrl;

  dio.options = dio.options.copyWith(baseUrl: baseUrl);

  return RepositoryCommonImpl(dio: dio);
});
