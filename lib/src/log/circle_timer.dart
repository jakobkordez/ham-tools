import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';

class CircleTimer extends StatefulWidget {
  final void Function()? onMinute;

  const CircleTimer({Key? key, this.onMinute}) : super(key: key);

  @override
  State<CircleTimer> createState() => _CircleTimerState();
}

class _CircleTimerState extends State<CircleTimer> {
  Timer? _minuteTimer;

  void _buildTimer() {
    if (widget.onMinute == null) return;
    final now = DateTime.now();
    final target =
        DateTime(now.year, now.month, now.day, now.hour, now.minute + 1);
    _minuteTimer = Timer(target.difference(now), () {
      widget.onMinute!();
      _minuteTimer?.cancel();
      _buildTimer();
    });
  }

  @override
  void initState() {
    super.initState();
    _buildTimer();
  }

  @override
  void dispose() {
    _minuteTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 1,
        child: TimerBuilder(
          generator: fromIterable(_scheduler()),
          builder: (context) {
            final now = DateTime.now().toUtc().second;
            return TweenAnimationBuilder<double>(
              duration: const Duration(seconds: 1),
              tween: Tween(begin: now / 60, end: (now + 1) / 60),
              builder: (context, value, _) => CircularProgressIndicator(
                backgroundColor: Colors.grey.shade300,
                value: value,
              ),
            );
          },
        ),
      );

  Iterable<DateTime> _scheduler() sync* {
    var now = DateTime.now().toUtc();
    now = DateTime.utc(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second,
    );
    while (true) {
      yield now = now.add(const Duration(seconds: 1));
    }
  }
}
