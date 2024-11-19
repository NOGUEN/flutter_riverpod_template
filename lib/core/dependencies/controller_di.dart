import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_template/core/base/base_state.dart';
import 'package:riverpod_template/presentation/controller/my_page_controller.dart';

final myControllerProvider =
    AutoDisposeStateNotifierProvider<MyPageController, Map<String, BaseState>>(
  (ref) => MyPageController(),
);
