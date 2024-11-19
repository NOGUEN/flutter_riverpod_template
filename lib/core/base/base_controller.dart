import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_template/core/build_config.dart';
import 'package:riverpod_template/core/enum/component_state.dart';
import 'base_state.dart';

abstract class BaseController extends StateNotifier<Map<String, BaseState>> {
  BaseController() : super({});

  Logger get logger => BuildConfig.instance.logger;

  void showToastMessage({required String message}) =>
      Fluttertoast.showToast(msg: message);

  /// 특정 State 추가
  void addState(String componentKey, BaseState initialState) {
    state = {...state, componentKey: initialState};
  }

  /// 특정 State 업데이트
  void updateState(String componentKey, BaseState newState) {
    if (!state.containsKey(componentKey)) {
      throw Exception("State with key $componentKey not found.");
    }
    state = {...state, componentKey: newState};
  }

  /// 특정 State 가져오기
  BaseState? getState(String componentKey) {
    return state[componentKey];
  }

  /// 특정 State의 ComponentState 업데이트
  void updateComponentState(
      String componentKey, ComponentState newComponentState) {
    final currentState = state[componentKey];
    if (currentState != null) {
      updateState(
        componentKey,
        currentState.copyWith(componentState: newComponentState),
      );
    } else {
      throw Exception("State with key $componentKey not found.");
    }
  }

  dynamic perform<T>({
    required String componentKey,
    required Future<T> Function() networkCall,
    Function(T response)? onSuccess,
    Function(Exception exception)? onError,
  }) async {
    // `componentKey`에 해당하는 상태 가져오기
    final componentState = state[componentKey];

    if (componentState == null) {
      throw Exception("Component with key $componentKey not found.");
    }

    try {
      // 상태를 LOADING으로 설정
      updateState(
        componentKey,
        componentState.copyWith(componentState: ComponentState.LOADING),
      );

      // 네트워크 호출 수행
      final T response = await networkCall();

      // 상태를 SUCCESS로 설정
      updateState(
        componentKey,
        componentState.copyWith(componentState: ComponentState.SUCCESS),
      );

      // 성공 콜백 실행
      if (onSuccess != null) {
        onSuccess(response);
      }

      return response;
    } catch (e) {
      logger.e("Error in perform for $componentKey: $e");

      // 상태를 ERROR로 설정
      updateState(
        componentKey,
        componentState.copyWith(componentState: ComponentState.ERROR),
      );

      // 에러 콜백 실행
      if (onError != null) {
        onError(e as Exception);
      } else {
        showToastMessage(message: "Error occurred: $e");
      }

      return null;
    }
  }
}
