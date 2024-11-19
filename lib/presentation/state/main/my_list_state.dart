import 'package:riverpod_template/core/base/base_state.dart';
import 'package:riverpod_template/core/enum/component_state.dart';

class MyListState extends BaseState<MyListState> {
  final List<String>? data;

  MyListState({
    this.data,
    super.componentState,
  });

  @override
  MyListState copyWith({ComponentState? componentState, List<String>? data}) {
    return MyListState(
      data: data ?? this.data,
      componentState: componentState ?? this.componentState,
    );
  }
}
