import 'package:riverpod_template/core/base/base_state.dart';
import 'package:riverpod_template/core/enum/component_state.dart';

class MyComponentState extends BaseState<MyComponentState> {
  final String? data;

  MyComponentState({
    this.data,
    super.componentState,
  });

  @override
  MyComponentState copyWith({ComponentState? componentState, String? data}) {
    return MyComponentState(
      data: data ?? this.data,
      componentState: componentState ?? this.componentState,
    );
  }
}
