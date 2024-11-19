import 'package:riverpod_template/core/enum/component_state.dart';

abstract class BaseState<T> {
  final ComponentState componentState;

  BaseState({this.componentState = ComponentState.DEFAULT});

  T copyWith({ComponentState? componentState});
}
