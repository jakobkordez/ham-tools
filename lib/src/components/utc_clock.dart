import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';

class UtcClock extends StatelessWidget {
  final _format = DateFormat.Hm();

  UtcClock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => TimerBuilder(
        generator: fromIterable(_sheduler()),
        builder: (context) {
          final now = DateTime.now().toUtc();
          final tTheme =
              Theme.of(context).textTheme.displaySmall!.copyWith(height: 1);

          return RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: _format.format(now),
                  style: tTheme,
                ),
                TextSpan(
                  text: ':${'${now.second}'.padLeft(2, '0')}',
                  style: tTheme.copyWith(fontSize: tTheme.fontSize! * 0.6),
                ),
                TextSpan(
                  text: '  UTC',
                  style: tTheme.copyWith(fontSize: tTheme.fontSize! * 0.4),
                ),
              ],
            ),
          );
        },
      );

  Iterable<DateTime> _sheduler() sync* {
    final now = DateTime.now().toUtc();
    final start = DateTime.utc(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second,
    );
    int sec = 0;
    while (true) {
      ++sec;
      yield start.add(Duration(seconds: sec));
    }
  }
}
