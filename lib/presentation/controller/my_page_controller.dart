import 'package:flutter/cupertino.dart';
import 'package:riverpod_template/core/base/base_controller.dart';
import 'package:riverpod_template/core/enum/component_state.dart';
import 'package:riverpod_template/presentation/state/main/my_component_state.dart';
import 'package:riverpod_template/presentation/state/main/my_list_state.dart';

class MyPageController extends BaseController {
  MyPageController() {
    addState("widgetA", MyComponentState());
    addState("widgetB", MyComponentState());
    addState("widgetC", MyListState());
  }

  void loadData(String componentKey) async {
    updateComponentState(componentKey, ComponentState.LOADING);

    await Future.delayed(const Duration(seconds: 2)); // Mock API call
    final newData = "Loaded data for $componentKey";

    updateState(
      componentKey,
      MyComponentState(data: newData, componentState: ComponentState.SUCCESS),
    );
  }

  Future<void> getData<String>({required componentKey}) async {
    return await perform(
        componentKey: componentKey,
        networkCall: () async {
          debugPrint("getData");
          await Future.delayed(const Duration(seconds: 2)); // Mock API call
          final newData = "Loaded data for $componentKey";
          return newData;
        },
        onSuccess: (response) {
          updateState(
            componentKey,
            MyComponentState(
                data: response, componentState: ComponentState.SUCCESS),
          );
        });
  }

  Future<void> getList<List>({required componentKey}) async {
    return await perform(
        componentKey: componentKey,
        networkCall: () async {
          debugPrint("getData");
          await Future.delayed(const Duration(seconds: 2)); // Mock API call
          final newData = [
            "Loaded data for $componentKey",
          ];
          return newData;
        },
        onSuccess: (response) {
          updateState(
            componentKey,
            MyListState(data: response, componentState: ComponentState.SUCCESS),
          );
        });
  }
}
