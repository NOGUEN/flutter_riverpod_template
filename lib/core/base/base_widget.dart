import 'package:flutter/material.dart';
import 'package:riverpod_template/core/base/base_state.dart';
import 'package:riverpod_template/core/enum/component_state.dart';

abstract class BaseWidget<T extends BaseState> extends StatelessWidget {
  final T state;

  const BaseWidget({super.key, required this.state});

  /// 메인 위젯 빌드
  Widget buildWidget(BuildContext context, T state);

  /// 로딩 상태 처리
  Widget buildLoadingWidget(BuildContext context) => const Center(
        child: CircularProgressIndicator(),
      );

  /// 에러 상태 처리
  Widget buildErrorWidget(BuildContext context, String errorMessage) => Center(
        child: Text(
          "Error: $errorMessage",
          style: const TextStyle(color: Colors.red),
        ),
      );

  /// 성공 상태 처리
  Widget buildSuccessWidget(BuildContext context, T state) =>
      buildWidget(context, state);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: _buildBasedOnState(context),
    );
  }

  Widget _buildBasedOnState(BuildContext context) {
    if (state.componentState == ComponentState.LOADING) {
      return buildLoadingWidget(context);
    } else if (state.componentState == ComponentState.ERROR) {
      return buildErrorWidget(context, "An error occurred.");
    } else if (state.componentState == ComponentState.SUCCESS) {
      return buildSuccessWidget(context, state);
    }

    // 기본 상태
    return buildWidget(context, state);
  }
}
