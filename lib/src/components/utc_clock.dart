import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';

class UtcClock extends StatelessWidget {
  final _format = DateFormat.Hm();

  UtcClock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => TimerBuilder.periodic(
        const Duration(seconds: 1),
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
}
