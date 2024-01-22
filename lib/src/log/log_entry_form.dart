import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/field_controller.dart';
import '../models/log_entry.dart';
import '../utils/text_input_formatters.dart';
import 'bloc/log_bloc.dart';
import 'circle_timer.dart';
import 'cubit/new_log_entry_cubit.dart';
import 'models/date_input.dart';
import 'models/frequency_input.dart';
import 'models/time_input.dart';

part 'log_entry_fields.dart';

class LogEntryForm extends StatelessWidget {
  const LogEntryForm({super.key});

  @override
  Widget build(BuildContext context) => Card(
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 24,
              ),
              child: Text(
                'New entry',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            BlocProvider(
              create: (context) => NewLogEntryCubit(
                context.read<LogBloc>(),
              ),
              child: const Padding(
                padding: EdgeInsets.all(25),
                child: _LogEntryForm(),
              ),
            ),
          ],
        ),
      );
}

class _LogEntryForm extends StatelessWidget {
  const _LogEntryForm();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NewLogEntryCubit, NewLogEntryState>(
        buildWhen: (previous, current) =>
            previous.hasTimeOff != current.hasTimeOff ||
            previous.split != current.split ||
            previous.showContest != current.showContest ||
            previous.showComment != current.showComment ||
            previous.showSota != current.showSota ||
            previous.mode != current.mode,
        builder: (context, state) {
          final hasTimeOff = state.hasTimeOff;
          final split = state.split;
          final showContest = state.showContest;
          final showComment = state.showComment;
          final showSota = state.showSota;
          final hasSubMode = state.mode.subModes.isNotEmpty;

          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 450) {
                return _LogEntryFormSmall(
                  hasTimeOff: hasTimeOff,
                  split: split,
                  showContest: showContest,
                  showComment: showComment,
                  showSota: showSota,
                  hasSubMode: hasSubMode,
                );
              } else {
                return _LogEntryFormLarge(
                  hasTimeOff: hasTimeOff,
                  split: split,
                  showContest: showContest,
                  showComment: showComment,
                  showSota: showSota,
                  hasSubMode: hasSubMode,
                );
              }
            },
          );
        },
      );
}

class _LogEntryFormSmall extends StatelessWidget {
  final bool hasTimeOff;
  final bool split;
  final bool hasSubMode;
  final bool showSota;
  final bool showContest;
  final bool showComment;

  const _LogEntryFormSmall({
    required this.hasTimeOff,
    required this.split,
    required this.hasSubMode,
    required this.showSota,
    required this.showContest,
    required this.showComment,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Wrap(
            children: [
              SizedBox(width: 120, child: _DateOnInput()),
              SizedBox(width: 80, child: _TimeOnInput()),
              _TimeOnUpdater(),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Checkbox(
                value: hasTimeOff,
                onChanged: context.read<NewLogEntryCubit>().setHasTimeOff,
              ),
              const SizedBox(width: 5),
              const Text('Seperate time off'),
            ],
          ),
          if (hasTimeOff) ...[
            const SizedBox(height: 5),
            const _Wrap(
              children: [
                SizedBox(width: 120, child: _DateOffInput()),
                SizedBox(width: 80, child: _TimeOffInput()),
                _TimeOffUpdater(),
              ],
            ),
          ],
          const SizedBox(height: 10),
          _Hide(
            title: const Text('Frequency'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(flex: 2, child: _BandInput()),
                    SizedBox(width: 10),
                    Expanded(flex: 3, child: _FrequencyInput()),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _SplitCheckbox(),
                    SizedBox(width: 5),
                    Text('Split'),
                  ],
                ),
                if (split) ...[
                  const SizedBox(height: 8),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(flex: 2, child: _BandRxInput()),
                      SizedBox(width: 10),
                      Expanded(flex: 3, child: _FrequencyRxInput()),
                    ],
                  ),
                ],
              ],
            ),
          ),
          _Hide(
            title: const Text('Mode & Power'),
            child: _Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                const SizedBox(width: 100, child: _ModeInput()),
                if (hasSubMode)
                  const SizedBox(width: 150, child: _SubModeInput()),
                const SizedBox(width: 100, child: _PowerInput()),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const _CallsignInput(),
          const SizedBox(height: 10),
          const Row(
            children: [
              Expanded(child: _RstSentInput()),
              SizedBox(width: 10),
              Expanded(child: _RstRecvInput()),
            ],
          ),
          if (showSota) ...const [
            SizedBox(height: 20),
            _SotaRefInput(),
            SizedBox(height: 8),
            _MySotaRefInput(),
          ],
          if (showContest) ...[
            const SizedBox(height: 20),
            const Row(
              children: [
                Expanded(child: _ContestStxStringInput()),
                SizedBox(width: 10),
                Expanded(child: _ContestStxInput()),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Expanded(child: _ContestSrxStringInput()),
                SizedBox(width: 10),
                Expanded(child: _ContestSrxInput()),
              ],
            ),
          ],
          if (showComment) ...[
            const SizedBox(height: 20),
            const _CommentInput(),
          ],
          const SizedBox(height: 25),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _Wrap(
                  children: [
                    _ShowSotaButton(),
                    _ShowContestButton(),
                    _ShowCommentButton(),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: _SubmitButton(),
              ),
            ],
          )
        ],
      );
}

class _LogEntryFormLarge extends StatelessWidget {
  final bool hasTimeOff;
  final bool split;
  final bool hasSubMode;
  final bool showSota;
  final bool showContest;
  final bool showComment;

  const _LogEntryFormLarge({
    required this.hasTimeOff,
    required this.split,
    required this.hasSubMode,
    required this.showSota,
    required this.showContest,
    required this.showComment,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Wrap(
            children: [
              SizedBox(width: 120, child: _DateOnInput()),
              SizedBox(width: 80, child: _TimeOnInput()),
              _TimeOnUpdater(),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Checkbox(
                value: hasTimeOff,
                onChanged: context.read<NewLogEntryCubit>().setHasTimeOff,
              ),
              const SizedBox(width: 5),
              const Text('Seperate time off'),
            ],
          ),
          if (hasTimeOff)
            const _Wrap(
              children: [
                SizedBox(width: 120, child: _DateOffInput()),
                SizedBox(width: 80, child: _TimeOffInput()),
                _TimeOffUpdater(),
              ],
            ),
          const SizedBox(height: 10),
          _Hide(
            title: const Text('Frequency'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    SizedBox(width: 120, child: _BandInput()),
                    SizedBox(
                      width: 200,
                      child: _FrequencyInput(),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _SplitCheckbox(),
                        SizedBox(width: 5),
                        Text('Split'),
                      ],
                    ),
                  ],
                ),
                split
                    ? const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: _Wrap(
                          crossAxisAlignment: WrapCrossAlignment.end,
                          children: [
                            SizedBox(
                              width: 120,
                              child: _BandRxInput(),
                            ),
                            SizedBox(
                              width: 200,
                              child: _FrequencyRxInput(),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          _Hide(
            title: const Text('Mode & Power'),
            child: _Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                const SizedBox(width: 100, child: _ModeInput()),
                if (hasSubMode)
                  const SizedBox(width: 150, child: _SubModeInput()),
                const SizedBox(width: 100, child: _PowerInput()),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const _Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              SizedBox(width: 200, child: _CallsignInput()),
              SizedBox(width: 100, child: _RstSentInput()),
              SizedBox(width: 100, child: _RstRecvInput()),
            ],
          ),
          if (showSota) ...[
            const SizedBox(height: 20),
            const _Wrap(
              children: [
                SizedBox(width: 150, child: _SotaRefInput()),
                SizedBox(width: 150, child: _MySotaRefInput()),
              ],
            ),
          ],
          if (showContest) ...[
            const SizedBox(height: 20),
            const _Wrap(
              children: [
                SizedBox(
                  width: 150,
                  child: _ContestStxStringInput(),
                ),
                SizedBox(width: 150, child: _ContestStxInput()),
              ],
            ),
            const SizedBox(height: 8),
            const _Wrap(
              children: [
                SizedBox(
                  width: 150,
                  child: _ContestSrxStringInput(),
                ),
                SizedBox(width: 150, child: _ContestSrxInput()),
              ],
            ),
          ],
          if (showComment) ...[
            const SizedBox(height: 20),
            const _CommentInput(),
          ],
          const SizedBox(height: 25),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _Wrap(
                  children: [
                    _ShowSotaButton(),
                    _ShowContestButton(),
                    _ShowCommentButton(),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: _SubmitButton(),
              ),
            ],
          )
        ],
      );
}

class _Wrap extends Wrap {
  const _Wrap({
    super.children,
    super.crossAxisAlignment = WrapCrossAlignment.center,
  }) : super(
          runSpacing: 8,
          spacing: 10,
        );
}

class _Hide extends StatefulWidget {
  final Widget title;
  final Widget child;
  final bool initiallyHidden;

  const _Hide({
    required this.title,
    required this.child,
    // TODO: Remove
    // ignore: unused_element
    this.initiallyHidden = kDebugMode,
  });

  @override
  State<_Hide> createState() => _HideState();
}

class _HideState extends State<_Hide> {
  late bool hidden;

  @override
  void initState() {
    super.initState();
    hidden = widget.initiallyHidden;
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Divider(
            icon: hidden
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility),
            label: widget.title,
            onPressed: () => setState(() => hidden = !hidden),
          ),
          if (!hidden) ...[
            const SizedBox(height: 10),
            widget.child,
            const SizedBox(height: 15),
          ],
        ],
      );
}

class _Divider extends StatelessWidget {
  final Widget icon;
  final Widget label;
  final VoidCallback onPressed;

  const _Divider({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            splashRadius: 20,
            iconSize: 20,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            icon: icon,
            onPressed: onPressed,
          ),
          DefaultTextStyle(
            style: Theme.of(context).textTheme.labelMedium!,
            child: label,
          ),
          const SizedBox(width: 10),
          const Expanded(child: Divider()),
        ],
      );
}
