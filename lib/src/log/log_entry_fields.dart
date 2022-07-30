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
      BlocListener<NewLogEntryCubit, NewLogEntryState>(
        listenWhen: (previous, current) => previous.clean != current.clean,
        listener: (context, state) {
          if (state.clean) focusNode.requestFocus();
        },
        child: _FieldUpdater(
          getValue: (state) => state.callsign,
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
            ),
            style: const TextStyle(fontFamily: 'RobotoMono'),
          ),
        ),
      );
}

class _DateOnInput extends StatelessWidget {
  const _DateOnInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _FieldUpdater(
        getValue: (state) => state.dateOn,
        builder: (context, controller) => TextFormField(
          controller: controller,
          onChanged: context.read<NewLogEntryCubit>().setDateOn,
          decoration: const InputDecoration(labelText: 'Date'),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) =>
              value != null && NewLogEntryCubit.tryParseDate(value) == null
                  ? 'Invalid date'
                  : null,
        ),
      );
}

class _TimeOnInput extends StatelessWidget {
  const _TimeOnInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _FieldUpdater(
        getValue: (state) => state.timeOn,
        builder: (context, controller) => TextFormField(
          controller: controller,
          onChanged: context.read<NewLogEntryCubit>().setTimeOn,
          decoration: const InputDecoration(labelText: 'Time'),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) =>
              value != null && NewLogEntryCubit.tryParseTime(value) == null
                  ? 'Invalid time'
                  : null,
        ),
      );
}

class _TimeUpdater extends StatelessWidget {
  const _TimeUpdater({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NewLogEntryCubit, NewLogEntryState>(
        buildWhen: (previous, current) => previous.autoTime != current.autoTime,
        builder: (context, state) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            state.autoTime
                ? SizedBox(
                    width: 20,
                    child: CircleTimer(
                      onMinute: context.read<NewLogEntryCubit>().setTimeOnNow,
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

class _TimeOnNowButton extends StatelessWidget {
  const _TimeOnNowButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: context.read<NewLogEntryCubit>().setTimeOnNow,
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
            border: OutlineInputBorder(),
          ),
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
        getValue: (state) => state.frequency,
        builder: (context, controller) => TextFormField(
          controller: controller,
          inputFormatters: [DoubleTextFormatter()],
          onChanged: context.read<NewLogEntryCubit>().setFreq,
          decoration: const InputDecoration(
            labelText: 'Frequency',
            suffixText: 'MHz',
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
            border: OutlineInputBorder(),
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
        getValue: (state) => state.frequencyRx,
        builder: (context, controller) => TextFormField(
          controller: controller,
          inputFormatters: [DoubleTextFormatter()],
          onChanged: context.read<NewLogEntryCubit>().setFreqRx,
          decoration: const InputDecoration(
            labelText: 'Receive frequency',
            suffixText: 'MHz',
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
            border: OutlineInputBorder(),
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
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () =>
                        context.read<NewLogEntryCubit>().setSubMode(null),
                    icon: const Icon(Icons.clear),
                  ),
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
          ),
        ),
      );
}

class _RstSentButton extends StatelessWidget {
  const _RstSentButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NewLogEntryCubit, NewLogEntryState>(
        buildWhen: (previous, current) => previous.mode != current.mode,
        builder: (context, state) {
          final def = state.mode.defaultReport;
          if (def == null) return const SizedBox.shrink();

          return Focus(
            descendantsAreFocusable: false,
            skipTraversal: true,
            child: ElevatedButton(
              onPressed: () => context.read<NewLogEntryCubit>().setRstSent(def),
              child: Text(def),
            ),
          );
        },
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
          ),
        ),
      );
}

class _RstRecvButton extends StatelessWidget {
  const _RstRecvButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NewLogEntryCubit, NewLogEntryState>(
        buildWhen: (previous, current) => previous.mode != current.mode,
        builder: (context, state) {
          final def = state.mode.defaultReport;
          if (def == null) return const SizedBox.shrink();

          return Focus(
            descendantsAreFocusable: false,
            skipTraversal: true,
            child: ElevatedButton(
              onPressed: () => context.read<NewLogEntryCubit>().setRstRecv(def),
              child: Text(def),
            ),
          );
        },
      );
}

class _QthInput extends StatelessWidget {
  const _QthInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => TextFormField(
        decoration: const InputDecoration(
          labelText: 'QTH',
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

class _NotesInput extends StatelessWidget {
  const _NotesInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Notes',
        ),
      );
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: () {
          final b = context.read<NewLogEntryCubit>();
          context.read<LogBloc>().add(LogEntryAdded(b.state.asLogEntry()));
          b.clear();
        },
        child: const Text('Submit'),
      );
}

class _FieldUpdater extends StatefulWidget {
  final String Function(NewLogEntryState state) getValue;
  final Widget Function(BuildContext context, TextEditingController controller)
      builder;

  const _FieldUpdater({
    required this.getValue,
    required this.builder,
  });

  @override
  State<_FieldUpdater> createState() => _FieldUpdaterState();
}

class _FieldUpdaterState extends State<_FieldUpdater> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.getValue(context.read<NewLogEntryCubit>().state);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<NewLogEntryCubit, NewLogEntryState>(
        listenWhen: (p, c) => widget.getValue(p) != widget.getValue(c),
        listener: (context, state) {
          final v = widget.getValue(state);
          if (_controller.text != v) {
            _controller.text = v;
          }
        },
        child: widget.builder(context, _controller),
      );
}
