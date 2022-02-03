import 'package:flutter/material.dart';
import 'package:ham_tools/src/utils/callsign_util.dart';

class DxccList extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final List<DxccEntity> entities;

  const DxccList({
    Key? key,
    required this.entities,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView.separated(
        padding: padding,
        shrinkWrap: true,
        separatorBuilder: (_, __) =>
            Container(height: 1, color: Colors.grey.shade200),
        itemCount: entities.length,
        itemBuilder: (_, i) {
          final e = entities[i];

          return Column(
            children: [
              ListTile(
                leading: Tooltip(
                  message: e.flag,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                    child: Image.asset(
                      'assets/flags/64/${e.flag}.png',
                      width: 32,
                    ),
                  ),
                ),
                title: Text(e.name),
                subtitle: Text(e.prefix),
              ),
              if (e.sub.isNotEmpty)
                DxccList(
                  entities: e.sub,
                  padding: const EdgeInsets.only(left: 48),
                ),
            ],
          );
        },
      );
}
