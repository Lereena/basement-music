import 'package:flutter/material.dart';

class AnimatedProgressBar extends StatefulWidget {
  final double value;
  final double min;
  final double max;

  const AnimatedProgressBar({
    super.key,
    required this.value,
    this.min = 0,
    this.max = 1,
  });

  @override
  _AnimatedProgressBarState createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final TweenSequence<double> _tweenSequence;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _tweenSequence = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: widget.min,
          end: widget.value,
        ),
        weight: 1,
      ),
    ]);
    _animation = _tweenSequence.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linearToEaseOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(AnimatedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != 0) {
      _animationController.reset();
      _animation = Tween<double>(
        begin: oldWidget.value,
        end: widget.value,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.linear,
        ),
      );
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return LinearProgressIndicator(
          value: _animation.value,
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        );
      },
    );
  }
}
