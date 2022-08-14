import 'package:flutter/material.dart';

class SettingsCard extends StatelessWidget {
  final Widget title;
  final Widget child;
  final List<Widget> actions;
  final EdgeInsets padding;

  const SettingsCard({
    super.key,
    required this.title,
    required this.child,
    this.actions = const [],
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Card(
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                color: theme.splashColor,
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextStyle(
                        style: theme.textTheme.headlineSmall!
                            .copyWith(fontSize: 22),
                        child: title,
                      ),
                    ),
                    ...actions,
                  ],
                ),
              ),
              Padding(
                padding: padding,
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
