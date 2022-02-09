import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ham_tools/src/log/cubit/new_log_entry_cubit.dart';
import 'package:ham_tools/src/models/log_entry.dart';
import 'package:ham_tools/src/utils/text_input_formatters.dart';

part 'log_entry_fields.dart';

class LogEntryForm extends StatelessWidget {
  const LogEntryForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => NewLogEntryCubit(),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 200, child: _CallsignInput()),
              const SizedBox(height: 15),
              Row(
                children: const [
                  SizedBox(width: 150, child: _DateOnInput()),
                  SizedBox(width: 10),
                  SizedBox(width: 100, child: _TimeOnInput()),
                  SizedBox(width: 10),
                  _TimeOnNowButton(),
                  SizedBox(width: 20),
                  // Checkbox(value: false, onChanged: (_) {}),
                  // SizedBox(width: 5),
                  // Text('Seperate time off'),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: const [
                  SizedBox(width: 100, child: _BandInput()),
                  SizedBox(width: 10),
                  SizedBox(width: 200, child: _FrequencyInput()),
                  SizedBox(width: 10),
                  SizedBox(width: 100, child: _ModeInput()),
                  SizedBox(width: 20),
                  _SplitCheckbox(),
                  SizedBox(width: 5),
                  Text('Split'),
                ],
              ),
              BlocBuilder<NewLogEntryCubit, NewLogEntryState>(
                builder: (context, state) => state.split
                    ? Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: const [
                            SizedBox(width: 100, child: _BandRxInput()),
                            SizedBox(width: 10),
                            SizedBox(width: 200, child: _FrequencyRxInput()),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
              // Row(
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
      );
}
