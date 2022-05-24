import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ham_tools/src/log/bloc/log_bloc.dart';
import 'package:ham_tools/src/log/circle_timer.dart';
import 'package:ham_tools/src/log/cubit/new_log_entry_cubit.dart';
import 'package:ham_tools/src/models/log_entry.dart';
import 'package:ham_tools/src/repository/repository.dart';
import 'package:ham_tools/src/utils/text_input_formatters.dart';

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
                      const SizedBox(width: 200, child: _CallsignInput()),
                      const SizedBox(height: 15),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: 8,
                        children: const [
                          SizedBox(width: 150, child: _DateOnInput()),
                          SizedBox(width: 10),
                          SizedBox(width: 100, child: _TimeOnInput()),
                          SizedBox(width: 10),
                          SizedBox(height: 25, child: CircleTimer()),
                          SizedBox(width: 10),
                          _TimeOnNowButton(),
                          SizedBox(width: 20),
                          // Checkbox(value: false, onChanged: (_) {}),
                          // SizedBox(width: 5),
                          // Text('Seperate time off'),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: 8,
                        children: [
                          const SizedBox(width: 120, child: _BandInput()),
                          const SizedBox(width: 10),
                          const SizedBox(width: 200, child: _FrequencyInput()),
                          const SizedBox(width: 10),
                          const SizedBox(width: 100, child: _ModeInput()),
                          const SizedBox(width: 20),
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
                        builder: (context, state) => state.split
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  runSpacing: 8,
                                  children: const [
                                    SizedBox(width: 120, child: _BandRxInput()),
                                    SizedBox(width: 10),
                                    SizedBox(
                                        width: 200, child: _FrequencyRxInput()),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 15),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: 8,
                        children: const [
                          SizedBox(width: 100, child: _RstSentInput()),
                          SizedBox(width: 10),
                          _RstSentButton(),
                          SizedBox(width: 20),
                          SizedBox(width: 100, child: _RstRecvInput()),
                          SizedBox(width: 10),
                          _RstRecvButton(),
                          SizedBox(width: 20),
                          SizedBox(width: 100, child: _PowerInput()),
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
