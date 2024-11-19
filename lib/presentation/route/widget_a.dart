import 'package:flutter/material.dart';
import 'package:riverpod_template/core/base/base_state.dart';
import 'package:riverpod_template/core/base/base_widget.dart';
import 'package:riverpod_template/core/const/app_color.dart';
import 'package:riverpod_template/core/enum/component_state.dart';
import 'package:riverpod_template/presentation/state/main/my_component_state.dart';
import 'package:riverpod_template/presentation/state/main/my_list_state.dart';

class WidgetA extends BaseWidget {
  const WidgetA({
    super.key,
    required this.title,
    required this.onPressed,
    required super.state,
  });

  final String title;
  final VoidCallback onPressed;

  @override
  Widget buildWidget(BuildContext context, BaseState state) {
    final myState = state as MyComponentState;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.blueGray,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Text(myState.data ?? title),
          ),
        ),
        ElevatedButton(onPressed: onPressed, child: Text("Load Data")),
      ],
    );
  }

  @override
  Widget buildLoadingWidget(BuildContext context) {
    return const SkeletonLoader(width: 100, height: 50);
  }

  @override
  Widget buildErrorWidget(BuildContext context, String errorMessage) {
    // TODO: implement buildErrorWidget
    return super.buildErrorWidget(context, errorMessage);
  }
}

class ListCell extends StatelessWidget {
  const ListCell({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Text("List Cell"),
    );
  }
}

class WidgetB extends BaseWidget {
  const WidgetB({
    super.key,
    required this.title,
    required this.onPressed,
    required super.state,
  });

  final String title;
  final VoidCallback onPressed;

  @override
  Widget buildWidget(BuildContext context, BaseState state) {
    final myState = state as MyListState;

    return Column(
      children: [
        Text(title),
        if (myState.componentState == ComponentState.LOADING)
          const CircularProgressIndicator(),
        if (myState.componentState == ComponentState.SUCCESS)
          Column(
              children:
                  myState.data?.map((e) => const ListCell()).toList() ?? []),
        ElevatedButton(onPressed: onPressed, child: Text("Load Data")),
      ],
    );
  }
}

class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8.0,
  });

  final double? width;
  final double? height;
  final double borderRadius;

  @override
  _SkeletonLoaderState createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: false);

    _animation = Tween<double>(begin: -1, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = widget.width ?? constraints.maxWidth;
          final height = widget.height ?? constraints.maxHeight;

          return Stack(
            children: [
              // Background skeleton
              Container(
                width: width,
                height: height,
                color: Colors.grey.shade300,
              ),
              // Animated gradient
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_animation.value * width, 0),
                    child: child,
                  );
                },
                child: Container(
                  width: width * 0.4, // Light band width
                  height: height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey.shade300.withOpacity(0),
                        Colors.white.withOpacity(0.4),
                        Colors.grey.shade300.withOpacity(0),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
