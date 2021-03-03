library bdaya_custom_splash;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

enum AnimationEffect {
  FadeIn,
  ZoomIn,
  ZoomOut,
  TopDown,
}

class BdayaCustomSplash extends StatefulWidget {
  final Color backgroundColor;
  final Widget Function(Widget? child) backgroundBuilder;
  final Future<Object> Function() initFunction;
  final Shimmer Function(Widget child)? shimmerBuilder;
  final AnimationEffect animationEffect;
  final void Function(Object result) onNavigateTo;
  final int splashDuration;
  final Widget Function() logoBuilder;

  const BdayaCustomSplash({
    Key? key,
    required this.backgroundBuilder,
    required this.initFunction,
    this.shimmerBuilder,
    this.animationEffect = AnimationEffect.FadeIn,
    required this.onNavigateTo,
    this.splashDuration = 3,
    required this.logoBuilder,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  _BdayaCustomSplashState createState() => _BdayaCustomSplashState();
}

class _BdayaCustomSplashState extends State<BdayaCustomSplash>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  Future<Object>? _initFuture;

  @override
  void initState() {
    super.initState();

    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));

    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInCirc));

    _animationController.forward();
    _initFuture = widget.initFunction();
    startTime();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Timer startTime() {
    var _duration = new Duration(seconds: widget.splashDuration);
    return Timer(
      _duration,
      () {
        print('Timer Elapsed');
        _initFuture!.then((value) {
          print('Future Done');
          widget.onNavigateTo(value);
        });
      },
    );
  }

  Widget? _buildAnimation(Widget child) {
    switch (widget.animationEffect) {
      case AnimationEffect.FadeIn:
        {
          return FadeTransition(
              opacity: _animation as Animation<double>, child: child);
        }
      case AnimationEffect.ZoomIn:
        {
          return ScaleTransition(
              scale: _animation as Animation<double>, child: child);
        }
      case AnimationEffect.ZoomOut:
        {
          return ScaleTransition(
              scale: Tween(begin: 1.5, end: 0.6).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.easeInCirc,
                ),
              ),
              child: child);
        }
      case AnimationEffect.TopDown:
        {
          return SizeTransition(
              sizeFactor: _animation as Animation<double>, child: child);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
      future: _initFuture,
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: widget.backgroundColor,
          body: widget.backgroundBuilder(
            _buildAnimation(
              widget.shimmerBuilder?.call(widget.logoBuilder()) ??
                  widget.logoBuilder(),
            ),
          ),
        );
      },
    );
  }
}
