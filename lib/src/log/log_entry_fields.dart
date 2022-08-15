part of 'log_entry_form.dart';

class _CallsignInput extends StatefulWidget {
  const _CallsignInput({Key? key}) : super(key: key);

  @override
  State<_CallsignInput> createState() => _CallsignInputState();
}

class _CallsignInputState extends State<_CallsignInput> {
  final focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<NewLogEntryCubit, NewLogEntryState>(
        listenWhen: (previous, current) => previous.clean != current.clean,
        listener: (context, state) {
          if (state.clean) focusNode.requestFocus();
        },
        buildWhen: (previous, current) => previous.callsign != current.callsign,
        builder: (context, state) => _FieldUpdater(
          getValue: (state) => state.callsign.value,
          builder: (context, controller) => TextFormField(
            focusNode: focusNode,
            controller: controller,
            autofocus: true,
            onChanged: context.read<NewLogEntryCubit>().setCallsign,
            inputFormatters: [UpperCaseTextFormatter()],
            decoration: InputDecoration(
              labelText: 'Callsign',
              labelStyle: TextStyle(
                fontFamily: Theme.of(context).textTheme.bodyText2?.fontFamily,
              ),
              errorText: state.callsign.status == FormzInputStatus.invalid
                  ? 'Callsign cannot be empty'
                  : null,
            ),
            style: const TextStyle(fontFamily: 'RobotoMono'),
            onFieldSubmitted: (_) => context.read<NewLogEntryCubit>().submit(),
          ),
        ),
      );
}

class _DateOnInput extends StatelessWidget {
  const _DateOnInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _FieldUpdater(
        getValue: (state) => state.dateOn.value,
        builder: (context, controller) =>
            BlocBuilder<NewLogEntryCubit, NewLogEntryState>(
          builder: (context, state) => TextFormField(
            controller: controller,
            onChanged: context.read<NewLogEntryCubit>().setDateOn,
            decoration: InputDecoration(
              labelText: 'Date',
              errorText: state.dateOn.error == null
                  ? null
                  : state.dateOn.error == DateInputError.empty
                      ? 'Date is required'
                      : 'Invalid date',
            ),
          ),
        ),
      );
}

class _TimeOnInput extends StatelessWidget {
  const _TimeOnInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _FieldUpdater(
        getValue: (state) => state.timeOn.value,
        builder: (context, controller) =>
            BlocBuilder<NewLogEntryCubit, NewLogEntryState>(
          builder: (context, state) => TextFormField(
            controller: controller,
            onChanged: context.read<NewLogEntryCubit>().setTimeOn,
            decoration: InputDecoration(
              labelText: 'Time',
              errorText: state.timeOn.error == null
                  ? null
                  : state.timeOn.error == TimeInputError.empty
                      ? 'Time is required'
                      : 'Invalid time',
            ),
          ),
        ),
      );
}

class _TimeOnUpdater extends StatelessWidget {
  const _TimeOnUpdater({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NewLogEntryCubit, NewLogEntryState>(
        buildWhen: (previous, current) =>
            previous.autoTime != current.autoTime ||
            previous.hasTimeOff != current.hasTimeOff,
        builder: (context, state) => Row(
          mainAxisSize: MainAxisSize.min,
          children: state.hasTimeOff
              ? [const _TimeOnNowButton()]
              : [
                  state.autoTime
                      ? SizedBox(
                          width: 20,
                          child: CircleTimer(
                            onMinute:
                                context.read<NewLogEntryCubit>().setTimeOnNow,
                          ),
                        )
                      : const _TimeOnNowButton(),
                  const SizedBox(width: 8),
                  Checkbox(
                    value: state.autoTime,
                    onChanged: context.read<NewLogEntryCubit>().setAutoTime,
                  ),
                  const Text('Auto'),
                ],
        ),
      );
}

class _TimeOffUpdater extends StatelessWidget {
  const _TimeOffUpdater({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NewLogEntryCubit, NewLogEntryState>(
        buildWhen: (previous, current) =>
            previous.autoTime != current.autoTime ||
            previous.hasTimeOff != current.hasTimeOff,
        builder: (context, state) => Row(
          mainAxisSize: MainAxisSize.min,
          children: state.hasTimeOff
              ? [
                  state.autoTime
                      ? SizedBox(
                          width: 20,
                          child: CircleTimer(
                            onMinute:
                                context.read<NewLogEntryCubit>().setTimeOffNow,
                          ),
                        )
                      : const _TimeOnNowButton(),
                  const SizedBox(width: 8),
                  Checkbox(
                    value: state.autoTime,
                    onChanged: context.read<NewLogEntryCubit>().setAutoTime,
                  ),
                  const Text('Auto'),
                ]
              : [const _TimeOffNowButton()],
        ),
      );
}

class _TimeOnNowButton extends StatelessWidget {
  const _TimeOnNowButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: context.read<NewLogEntryCubit>().setTimeOnNow,
        child: const Text('Now'),
      );
}

class _DateOffInput extends StatelessWidget {
  const _DateOffInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _FieldUpdater(
        getValue: (state) => state.dateOff.value,
        builder: (context, controller) =>
            BlocBuilder<NewLogEntryCubit, NewLogEntryState>(
          builder: (context, state) => TextFormField(
            controller: controller,
            onChanged: context.read<NewLogEntryCubit>().setDateOff,
            decoration: InputDecoration(
              labelText: 'Date off',
              errorText: state.dateOff.error == null
                  ? null
                  : state.dateOff.error == DateInputError.empty
                      ? 'Date is required'
                      : 'Invalid date',
            ),
          ),
        ),
      );
}

class _TimeOffInput extends StatelessWidget {
  const _TimeOffInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _FieldUpdater(
        getValue: (state) => state.timeOff.value,
        builder: (context, controller) =>
            BlocBuilder<NewLogEntryCubit, NewLogEntryState>(
          builder: (context, state) => TextFormField(
            controller: controller,
            onChanged: context.read<NewLogEntryCubit>().setTimeOff,
            decoration: InputDecoration(
              labelText: 'Time off',
              errorText: state.timeOff.error == null
                  ? null
                  : state.timeOff.error == TimeInputError.empty
                      ? 'Time is required'
                      : 'Invalid time',
            ),
          ),
        ),
      );
}

class _TimeOffNowButton extends StatelessWidget {
  const _TimeOffNowButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: context.read<NewLogEntryCubit>().setTimeOffNow,
        child: const Text('Now'),
      );
}

class _BandInput extends StatelessWidget {
  const _BandInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NewLogEntryCubit, NewLogEntryState>(
        buildWhen: (prev, curr) => prev.band != curr.band,
        builder: (context, state) => DropdownButtonFormField<Band>(
          decoration: const InputDecoration(
            labelText: 'Band',
          ),
          isExpanded: true,
          dropdownColor: Colors.white,
          value: state.band,
          onChanged: context.read<NewLogEntryCubit>().setBand,
          items: Band.values
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.label),
                  ))
              .toList(),
        ),
      );
}

class _FrequencyInput extends StatelessWidget {
  const _FrequencyInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _FieldUpdater(
        getValue: (state) => state.frequency.value,
        builder: (context, controller) =>
            BlocBuilder<NewLogEntryCubit, NewLogEntryState>(
          builder: (context, state) => TextFormField(
            controller: controller,
            inputFormatters: [DoubleTextFormatter()],
            onChanged: context.read<NewLogEntryCubit>().setFreq,
            decoration: InputDecoration(
              labelText: 'Frequency',
              suffixText: 'MHz',
              errorText: state.frequency.error == null
                  ? null
                  : state.frequency.error == FrequencyInputError.empty
                      ? 'Empty'
                      : 'Invalid value',
            ),
          ),
        ),
      );

  // TODO Scrollable Frequency Input
  // Listener(
  //   onPointerSignal: (event) {
  //     if (event is PointerScrollEvent) {
  //       final move = event.scrollDelta.dy > 0 ? -0.001 : 0.001;
  //       final bloc = context.read<NewLogEntryCubit>();
  //       bloc.setFreq('${bloc.state.frequency / 1000000 + move}');
  //     }
  //   },
}

class _BandRxInput extends StatelessWidget {
  const _BandRxInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NewLogEntryCubit, NewLogEntryState>(
        buildWhen: (prev, curr) => prev.bandRx != curr.bandRx,
        builder: (context, state) => DropdownButtonFormField<Band>(
          decoration: const InputDecoration(
            labelText: 'Receive Band',
          ),
          dropdownColor: Colors.white,
          value: state.bandRx,
          onChanged: context.read<NewLogEntryCubit>().setBandRx,
          items: Band.values
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.label),
                  ))
              .toList(),
        ),
      );
}

class _FrequencyRxInput extends StatelessWidget {
  const _FrequencyRxInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _FieldUpdater(
        getValue: (state) => state.frequencyRx.value,
        builder: (context, controller) =>
            BlocBuilder<NewLogEntryCubit, NewLogEntryState>(
          builder: (context, state) => TextFormField(
            controller: controller,
            inputFormatters: [DoubleTextFormatter()],
            onChanged: context.read<NewLogEntryCubit>().setFreqRx,
            decoration: InputDecoration(
              labelText: 'Receive frequency',
              suffixText: 'MHz',
              errorText: state.frequencyRx.error == null
                  ? null
                  : state.frequencyRx.error == FrequencyInputError.empty
                      ? 'Empty'
                      : 'Invalid value',
            ),
          ),
        ),
      );
}

class _ModeInput extends StatelessWidget {
  const _ModeInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NewLogEntryCubit, NewLogEntryState>(
        buildWhen: (prev, curr) => prev.mode != curr.mode,
        builder: (context, state) => DropdownButtonFormField<Mode>(
          decoration: const InputDecoration(
            labelText: 'Mode',
          ),
          dropdownColor: Colors.white,
          value: state.mode,
          onChanged: context.read<NewLogEntryCubit>().setMode,
          items: ModeUtil.topModes
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.name),
                  ))
              .toList(),
        ),
      );
}

class _SubModeInput extends StatelessWidget {
  const _SubModeInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NewLogEntryCubit, NewLogEntryState>(
        buildWhen: (prev, curr) =>
            prev.mode != curr.mode || prev.subMode != curr.subMode,
        builder: (context, state) => state.mode.subModes.isEmpty
            ? const SizedBox.shrink()
            : DropdownButtonFormField<SubMode>(
                decoration: InputDecoration(
                  labelText: 'Submode',
                  suffixIcon: state.subMode != null
                      ? IconButton(
                          onPressed: () =>
                              context.read<NewLogEntryCubit>().setSubMode(null),
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                ),
                dropdownColor: Colors.white,
                value: state.subMode,
                onChanged: context.read<NewLogEntryCubit>().setSubMode,
                items: state.mode.subModes
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name),
                        ))
                    .toList(),
              ),
      );
}

class _SplitCheckbox extends StatelessWidget {
  const _SplitCheckbox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NewLogEntryCubit, NewLogEntryState>(
        buildWhen: (prev, curr) => prev.split != curr.split,
        builder: (context, state) => Checkbox(
          value: state.split,
          onChanged: context.read<NewLogEntryCubit>().setSplit,
        ),
      );
}

class _PowerInput extends StatelessWidget {
  const _PowerInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _FieldUpdater(
        getValue: (state) => state.power,
        builder: (context, controller) => TextFormField(
          controller: controller,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: context.read<NewLogEntryCubit>().setPower,
          decoration: const InputDecoration(
            labelText: 'Power',
            suffixText: 'W',
          ),
        ),
      );
}

class _RstSentInput extends StatelessWidget {
  const _RstSentInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _FieldUpdater(
        getValue: (state) => state.rstSent,
        builder: (context, controller) => Focus(
          skipTraversal: true,
          onFocusChange: (value) {
            if (value) {
              if (controller.text.isEmpty) {
                final c = context.read<NewLogEntryCubit>();
                final rpt = c.state.mode.defaultReport ?? '';
                controller.text = rpt;
                c.setRstSent(rpt);
              }
              controller.selection = TextSelection(
                baseOffset: 0,
                extentOffset: controller.text.length,
              );
            }
          },
          child: TextFormField(
            controller: controller,
            onChanged: context.read<NewLogEntryCubit>().setRstSent,
            decoration: const InputDecoration(
              labelText: 'RST Sent',
            ),
            onFieldSubmitted: (_) => context.read<NewLogEntryCubit>().submit(),
          ),
        ),
      );
}

class _RstRecvInput extends StatelessWidget {
  const _RstRecvInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _FieldUpdater(
        getValue: (state) => state.rstRcvd,
        builder: (context, controller) => Focus(
          skipTraversal: true,
          onFocusChange: (value) {
            if (value) {
              if (controller.text.isEmpty) {
                final c = context.read<NewLogEntryCubit>();
                final rpt = c.state.mode.defaultReport ?? '';
                controller.text = rpt;
                c.setRstRecv(rpt);
              }
              controller.selection = TextSelection(
                baseOffset: 0,
                extentOffset: controller.text.length,
              );
            }
          },
          child: TextFormField(
            controller: controller,
            onChanged: context.read<NewLogEntryCubit>().setRstRecv,
            decoration: const InputDecoration(
              labelText: 'RST Rcvd',
            ),
            onFieldSubmitted: (_) => context.read<NewLogEntryCubit>().submit(),
          ),
        ),
      );
}

class _GridsquareInput extends StatelessWidget {
  const _GridsquareInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Grid',
        ),
      );
}

class _NameInput extends StatelessWidget {
  const _NameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Name',
        ),
      );
}

class _CommentInput extends StatelessWidget {
  const _CommentInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _FieldUpdater(
        getValue: (state) => state.comment,
        builder: (context, controller) => TextFormField(
          controller: controller,
          onChanged: context.read<NewLogEntryCubit>().setComment,
          decoration: const InputDecoration(
            labelText: 'Comment',
          ),
          onFieldSubmitted: (_) => context.read<NewLogEntryCubit>().submit(),
        ),
      );
}

class _ShowCommentButton extends StatelessWidget {
  const _ShowCommentButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _ShowButton(
        getValue: (state) => state.showComment,
        setter: context.read<NewLogEntryCubit>().setShowComment,
        label: const Text('Comment'),
      );
}

class _ShowSotaButton extends StatelessWidget {
  const _ShowSotaButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _ShowButton(
        getValue: (state) => state.showSota,
        setter: context.read<NewLogEntryCubit>().setShowSota,
        label: const Text('SOTA'),
      );
}

class _SotaRefInput extends StatelessWidget {
  const _SotaRefInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _FieldUpdater(
        getValue: (state) => state.sotaRef.value,
        builder: (context, controller) => TextFormField(
          controller: controller,
          onChanged: context.read<NewLogEntryCubit>().setSotaRef,
          decoration: const InputDecoration(
            labelText: 'SOTA Reference',
          ),
          onFieldSubmitted: (_) => context.read<NewLogEntryCubit>().submit(),
        ),
      );
}

class _MySotaRefInput extends StatelessWidget {
  const _MySotaRefInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _FieldUpdater(
        getValue: (state) => state.mySotaRef.value,
        builder: (context, controller) => TextFormField(
          controller: controller,
          onChanged: context.read<NewLogEntryCubit>().setMySotaRef,
          decoration: const InputDecoration(
            labelText: 'My SOTA Reference',
          ),
          onFieldSubmitted: (_) => context.read<NewLogEntryCubit>().submit(),
        ),
      );
}

class _ShowContestButton extends StatelessWidget {
  const _ShowContestButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _ShowButton(
        getValue: (state) => state.showContest,
        setter: context.read<NewLogEntryCubit>().setShowContest,
        label: const Text('Contest'),
      );
}

class _ContestSrxInput extends StatelessWidget {
  const _ContestSrxInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _FieldUpdater(
        getValue: (state) => state.contestSrx,
        builder: (context, controller) => TextFormField(
          controller: controller,
          onChanged: context.read<NewLogEntryCubit>().setContestSrx,
          decoration: const InputDecoration(
            labelText: 'Serial received',
          ),
          onFieldSubmitted: (_) => context.read<NewLogEntryCubit>().submit(),
        ),
      );
}

class _ContestStxInput extends StatelessWidget {
  const _ContestStxInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _FieldUpdater(
        getValue: (state) => state.contestStx,
        builder: (context, controller) => TextFormField(
          controller: controller,
          onChanged: context.read<NewLogEntryCubit>().setContestStx,
          decoration: const InputDecoration(
            labelText: 'Serial sent',
          ),
          onFieldSubmitted: (_) => context.read<NewLogEntryCubit>().submit(),
        ),
      );
}

class _ContestSrxStringInput extends StatelessWidget {
  const _ContestSrxStringInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _FieldUpdater(
        getValue: (state) => state.contestSrxString,
        builder: (context, controller) => TextFormField(
          controller: controller,
          onChanged: context.read<NewLogEntryCubit>().setContestSrxString,
          decoration: const InputDecoration(
            labelText: 'Info received',
          ),
          onFieldSubmitted: (_) => context.read<NewLogEntryCubit>().submit(),
        ),
      );
}

class _ContestStxStringInput extends StatelessWidget {
  const _ContestStxStringInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _FieldUpdater(
        getValue: (state) => state.contestStxString,
        builder: (context, controller) => TextFormField(
          controller: controller,
          onChanged: context.read<NewLogEntryCubit>().setContestStxString,
          decoration: const InputDecoration(
            labelText: 'Info sent',
          ),
          onFieldSubmitted: (_) => context.read<NewLogEntryCubit>().submit(),
        ),
      );
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: context.read<NewLogEntryCubit>().submit,
        child: const Text('Submit'),
      );
}

class _ShowButton extends StatelessWidget {
  final Widget label;
  final bool Function(NewLogEntryState state) getValue;
  final void Function(bool value) setter;

  const _ShowButton({
    super.key,
    required this.label,
    required this.getValue,
    required this.setter,
  });

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NewLogEntryCubit, NewLogEntryState>(
        builder: (context, state) {
          final value = getValue(state);

          return TextButton.icon(
            onPressed: () => setter(!value),
            icon: value ? const Icon(Icons.remove) : const Icon(Icons.add),
            label: label,
            style: value ? TextButton.styleFrom(primary: Colors.grey) : null,
          );
        },
      );
}

typedef _FieldUpdater = FieldController<NewLogEntryCubit, NewLogEntryState>;
