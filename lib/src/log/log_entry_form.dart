import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/log_entry.dart';
import '../repository/repository.dart';
import '../utils/text_input_formatters.dart';
import 'bloc/log_bloc.dart';
import 'circle_timer.dart';
import 'cubit/new_log_entry_cubit.dart';

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
                create: (_) => NewLogEntryCubit(snap.data),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: 8,
                        spacing: 10,
                        children: const [
                          SizedBox(width: 150, child: _DateOnInput()),
                          SizedBox(width: 100, child: _TimeOnInput()),
                          _TimeUpdater(),
                          // SizedBox(width: 20),
                          // Checkbox(value: false, onChanged: (_) {}),
                          // SizedBox(width: 5),
                          // Text('Seperate time off'),
                        ],
                      ),
                      const SizedBox(height: 15),
                      _Hide(
                        // TODO Remove
                        initiallyHidden: kDebugMode,
                        title: const Text('Frequency'),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              runSpacing: 8,
                              spacing: 10,
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
                            BlocBuilder<NewLogEntryCubit, NewLogEntryState>(
                              buildWhen: (previous, current) =>
                                  previous.split != current.split,
                              builder: (context, state) => state.split
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        runSpacing: 8,
                                        spacing: 10,
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
                            ),
                          ],
                        ),
                      ),
                      _Hide(
                        // TODO Remove
                        initiallyHidden: kDebugMode,
                        title: const Text('Power & Mode'),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runSpacing: 8,
                          spacing: 10,
                          children: const [
                            SizedBox(width: 100, child: _PowerInput()),
                            SizedBox(width: 100, child: _ModeInput()),
                            SizedBox(width: 150, child: _SubModeInput()),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: 8,
                        spacing: 20,
                        children: const [
                          SizedBox(width: 200, child: _CallsignInput()),
                          SizedBox(width: 100, child: _RstSentInput()),
                          // _RstSentButton(),
                          SizedBox(width: 100, child: _RstRecvInput()),
                          // _RstRecvButton(),
                        ],
                      ),
                      // const SizedBox(height: 15),
                      // Wrap(
                      // runSpacing: 8,
                      //   children: const [
                      //     SizedBox(width: 150, child: _NameInput()),
                      //     SizedBox(width: 10),
                      //     SizedBox(width: 150, child: _QthInput()),
                      //   ],
                      // ),
                      // const SizedBox(height: 15),
                      // const _NotesInput(),
                      const SizedBox(height: 15),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: _SubmitButton(),
                      ),
                    ],
                  ),
                ),
              ),
      );
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                splashRadius: 20,
                iconSize: 20,
                color: Colors.grey,
                icon: hidden
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
                onPressed: () => setState(() => hidden = !hidden),
              ),
              DefaultTextStyle(
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Colors.grey.shade700,
                    ),
                child: widget.title,
              ),
              const SizedBox(width: 10),
              const Expanded(child: Divider()),
            ],
          ),
          if (!hidden) ...[
            const SizedBox(height: 10),
            widget.child,
            const SizedBox(height: 15),
          ],
        ],
      );
}
