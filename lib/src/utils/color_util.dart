import 'dart:math';

import 'package:flutter/material.dart';

import '../models/log_entry.dart';

extension ColorUtil on Color {
  static Color genRandomColor(int seed, [Color mix = const Color(0xffaaaaaa)]) {
    final rand = Random(seed);
    final red = rand.nextInt(256);
    final green = rand.nextInt(256);
    final blue = rand.nextInt(256);

    return Color.fromARGB(
      255,
      (mix.red + 2 * red) ~/ 3,
      (mix.green + 2 * green) ~/ 3,
      (mix.blue + 2 * blue) ~/ 3,
    );
  }

  static const _primaries = [
    Colors.amber,
    Colors.blue,
    Colors.cyan,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.green,
    Colors.indigo,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.lime,
    Colors.orange,
    Colors.pink,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.yellow,
  ];

  static const _opacities = [300, 400, 500, 600, 700];

  static Color randomPrimary(int seed) {
    final rand = Random(seed);

    return _primaries[rand.nextInt(_primaries.length)]
        [_opacities[rand.nextInt(_opacities.length)]]!;
  }
}

extension BandColorUtil on Band {
  Color get color {
    switch (this) {
      case Band.mf160m:
        return const Color(0xff7cfc00);
      case Band.hf80m:
        return const Color(0xffe550e5);
      case Band.hf60m:
        return const Color(0xff00008b);
      case Band.hf40m:
        return const Color(0xff5959ff);
      case Band.hf30m:
        return const Color(0xff62d962);
      case Band.hf20m:
        return const Color(0xfff2c40c);
      case Band.hf17m:
        return const Color(0xfff2f261);
      case Band.hf15m:
        return const Color(0xffcca166);
      case Band.hf12m:
        return const Color(0xffb22222);
      case Band.hf10m:
        return const Color(0xffff69b4);
      case Band.vhf6m:
        return const Color(0xffff0000);
      case Band.vhf4m:
        return const Color(0xffcc0044);
      case Band.vhf2m:
        return const Color(0xffff1493);
      case Band.vhf1_25m:
        return const Color(0xffccff00);
      case Band.uhf70cm:
        return const Color(0xff999900);
      case Band.uhf23cm:
        return const Color(0xff5ab8c7);
      default:
        return const Color(0xffaaaaaa);
    }
  }

  Color get textColor {
    switch (this) {
      case Band.hf60m:
        return Colors.white;
      default:
        return Colors.black;
    }
  }
}
