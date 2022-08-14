import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../components/field_controller.dart';
import '../models/log_entry.dart';
import '../repository/repository.dart';
import '../utils/text_input_formatters.dart';
import 'bloc/log_bloc.dart';
import 'circle_timer.dart';
import 'cubit/new_log_entry_cubit.dart';
import 'models/date_input.dart';
import 'models/frequency_input.dart';
import 'models/time_input.dart';

part 'log_entry_fields.dart';

class LogEntryForm extends StatelessWidget {
  const LogEntryForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => FutureBuilder<LogEntry?>(
        future: context.read<Repository>().getLastLogEntry(),
        builder: (context, snap) => snap.connectionState != ConnectionState.done
            ? const Padding(
                padding: EdgeInsets.all(20),
                child: Center(child: CircularProgressIndicator()),
              )
            : BlocProvider(
                create: (context) => NewLogEntryCubit(
                  context.read<LogBloc>(),
                  snap.data,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(25),
                  child: _LogEntryForm(),
                ),
              ),
      );
}

class _LogEntryForm extends StatelessWidget {
  const _LogEntryForm({Key? key}) : super(key: key);

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

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Wrap(
                children: const [
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
                _Wrap(
                  children: const [
                    SizedBox(width: 120, child: _DateOffInput()),
                    SizedBox(width: 80, child: _TimeOffInput()),
                    _TimeOffUpdater(),
                  ],
                ),
              const SizedBox(height: 10),
              _Hide(
                // TODO Remove
                initiallyHidden: kDebugMode,
                title: const Text('Frequency'),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        const SizedBox(width: 120, child: _BandInput()),
                        const SizedBox(
                          width: 200,
                          child: _FrequencyInput(),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            _SplitCheckbox(),
                            SizedBox(width: 5),
                            Text('Split'),
                          ],
                        ),
                      ],
                    ),
                    split
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: _Wrap(
                              crossAxisAlignment: WrapCrossAlignment.end,
                              children: const [
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
                // TODO Remove
                initiallyHidden: kDebugMode,
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
              _Wrap(
                children: const [
                  SizedBox(width: 200, child: _CallsignInput()),
                  SizedBox(width: 100, child: _RstSentInput()),
                  SizedBox(width: 100, child: _RstRecvInput()),
                ],
              ),
              if (showSota) ...[
                const SizedBox(height: 20),
                _Wrap(
                  children: const [
                    SizedBox(width: 150, child: _SotaRefInput()),
                    SizedBox(width: 150, child: _MySotaRefInput()),
                  ],
                ),
              ],
              if (showContest) ...[
                const SizedBox(height: 20),
                _Wrap(
                  children: const [
                    SizedBox(
                      width: 150,
                      child: _ContestStxStringInput(),
                    ),
                    SizedBox(width: 150, child: _ContestStxInput()),
                  ],
                ),
                const SizedBox(height: 8),
                _Wrap(
                  children: const [
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: _Wrap(
                      children: const [
                        _ShowSotaButton(),
                        _ShowContestButton(),
                        _ShowCommentButton(),
                      ],
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: _SubmitButton(),
                  ),
                ],
              )
            ],
          );
        },
      );
}

class _Wrap extends Wrap {
  _Wrap({
    super.children,
    super.crossAxisAlignment = WrapCrossAlignment.center,
    super.runSpacing = 8,
    super.spacing = 10,
  });
}

class _Hide extends StatefulWidget {
  final Widget title;
  final Widget child;
  final bool initiallyHidden;

  const _Hide({
    Key? key,
    required this.title,
    required this.child,
    this.initiallyHidden = false,
  }) : super(key: key);

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
    super.key,
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
            color: Colors.grey,
            icon: icon,
            onPressed: onPressed,
          ),
          DefaultTextStyle(
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Colors.grey.shade700,
                ),
            child: label,
          ),
          const SizedBox(width: 10),
          const Expanded(child: Divider()),
        ],
      );
}
