// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_template/core/base/base_state.dart';
import '../build_config.dart';
import '../const/app_color.dart';
import 'base_controller.dart';

abstract class BaseRoute<T extends BaseController> extends ConsumerWidget {
  /// BaseRoute는 특정 Controller를 주입받아야 한다.
  final AutoDisposeStateNotifierProvider<T, Map<String, BaseState>>
      controllerProvider;

  BaseRoute({super.key, required this.controllerProvider});

  /// 메인 UI를 정의하는 추상 메서드
  Widget body(BuildContext context);

  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  final Logger logger = BuildConfig.instance.logger;

  late BuildContext mContext;

  late T c;

  //late Map<String, BaseState<dynamic>> states;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    mContext = context;

    // Controller 주입
    c = ref.read(controllerProvider.notifier);

    // 상태 가져오기
    //states = ref.watch(controllerProvider);

    return GestureDetector(
      child: Stack(
        children: [
          annotatedRegion(context),
        ],
      ),
    );
  }

  Widget annotatedRegion(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: setStatusBarColor() ?? AppColors.mainBackground,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Material(
        color: AppColors.mainBackground,
        child: pageScaffold(context, null, null),
      ),
    );
  }

  Widget pageScaffold(BuildContext context, WidgetRef? ref, T? controller) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset(),
      backgroundColor: AppColors.mainBackground,
      floatingActionButton: floatingActionButton(),
      appBar: appBar(),
      body: Container(
        decoration: setBackgroundDecoration(),
        child: pageContent(context),
      ),
      bottomNavigationBar: bottomNavigationBar(),
      drawer: drawer(),
    );
  }

  Widget pageContent(BuildContext context) {
    return SafeArea(child: body(context));
  }

  /// 로딩 상태를 확인하고 보여줌
  // Widget _showLoadingIfNeeded(Map<String, BaseState> states) {
  //   final isLoading = states.values
  //       .any((state) => state.componentState == ComponentState.LOADING);
  //   return isLoading ? const Loading() : const SizedBox.shrink();
  // }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
    );
  }

  Decoration? setBackgroundDecoration() {
    return null;
  }

  Color? setStatusBarColor() {
    return null;
  }

  Widget? floatingActionButton() {
    return null;
  }

  PreferredSizeWidget? appBar() {
    return null;
  }

  bool resizeToAvoidBottomInset() {
    return false;
  }

  Widget? bottomNavigationBar() {
    return null;
  }

  Widget? drawer() {
    return null;
  }
}
