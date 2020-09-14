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
  final Widget Function(Widget child) backgroundBuilder;
  final Future<Object> Function() initFunction;
  final Shimmer Function(Widget child) shimmerBuilder;
  final AnimationEffect animationEffect;
  final void Function(Object result) onNavigateTo;
  final int splashDuration;
  final Widget Function() logoBuilder;

  const BdayaCustomSplash({
    Key key,
    @required this.backgroundBuilder,
    @required this.initFunction,
    this.shimmerBuilder,
    this.animationEffect,
    @required this.onNavigateTo,
    this.splashDuration = 3,
    @required this.logoBuilder,
  }) : super(key: key);

  @override
  _BdayaCustomSplashState createState() => _BdayaCustomSplashState();
}

class _BdayaCustomSplashState extends State<BdayaCustomSplash>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  Future<Object> _initFuture;

  @override
  void initState() {
    super.initState();

    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));

    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInCirc));

    _animationController.forward();
    _initFuture =
        widget.initFunction(); //.then((value) => widget.onNavigateTo(value));
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
        _initFuture.then((value) => widget.onNavigateTo(value));
      },
    );
  }

  Widget _buildAnimation(Widget child) {
    switch (widget.animationEffect) {
      case AnimationEffect.FadeIn:
        {
          return FadeTransition(opacity: _animation, child: child);
        }
      case AnimationEffect.ZoomIn:
        {
          return ScaleTransition(scale: _animation, child: child);
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
          return SizeTransition(sizeFactor: _animation, child: child);
        }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
      future: _initFuture,
      builder: (context, snapshot) {
        return Scaffold(
          body: widget.backgroundBuilder(
            _buildAnimation(
              widget.logoBuilder(),
            ),
          ),
        );
      },
    );
  }
}