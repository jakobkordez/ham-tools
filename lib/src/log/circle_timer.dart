import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';

class CircleTimer extends StatelessWidget {
  const CircleTimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 1,
        child: TimerBuilder.periodic(
          const Duration(seconds: 1),
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
}
