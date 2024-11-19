import 'package:flutter/material.dart';
import 'package:riverpod_template/core/manager/route_manager.dart';

abstract class UtilDialog {
  static showCustomDialog(
      {BuildContext? context,
      required Widget widget,
      bool canDismissible = true}) {
    showGeneralDialog(
      context: context ?? RouteManager.instance.appContext,
      pageBuilder: (context, anim1, anim2) {
        return SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(type: MaterialType.transparency, child: widget),
            ],
          ),
        );
      },
      barrierDismissible: canDismissible,
      barrierLabel: MaterialLocalizations.of(RouteManager.instance.appContext)
          .modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
    );
  }
}
