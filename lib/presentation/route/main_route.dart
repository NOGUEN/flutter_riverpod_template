// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_template/core/base/base_route.dart';
import 'package:riverpod_template/core/base/base_state.dart';
import 'package:riverpod_template/core/dependencies/controller_di.dart';
import 'package:riverpod_template/presentation/controller/my_page_controller.dart';
import 'package:riverpod_template/presentation/route/widget_a.dart';
import 'package:riverpod_template/presentation/state/main/my_component_state.dart';
import 'package:riverpod_template/presentation/state/main/my_list_state.dart';

class MainRoute extends BaseRoute<MyPageController> {
  MainRoute({super.key, required super.controllerProvider});

  @override
  Widget body(BuildContext context) {
    debugPrint("MainRoute body");
    return Column(
      children: [
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            debugPrint("WidgetA");
            return WidgetA(
              title: '123',
              onPressed: () => c.getData(componentKey: "widgetA"),
              state: ref.watch(myControllerProvider)["widgetA"]
                  as BaseState<MyComponentState>,
            );
          },
        ),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            debugPrint("WidgetB");
            return WidgetA(
              title: '456',
              onPressed: () => c.getData(componentKey: "widgetB"),
              state: ref.watch(myControllerProvider)["widgetB"]
                  as BaseState<MyComponentState>,
            );
          },
        ),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            debugPrint("WidgetC");
            return WidgetB(
              title: '789',
              onPressed: () => c.getList(componentKey: "widgetC"),
              state: ref.watch(myControllerProvider)["widgetC"]
                  as BaseState<MyListState>,
            );
          },
        ),
      ],
    );
  }
}
