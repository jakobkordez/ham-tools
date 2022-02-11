part of 'log_entry_form.dart';

class _CallsignInput extends StatelessWidget {
  const _CallsignInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<NewLogEntryCubit, LogEntry>(
        buildWhen: (p, c) => p.callsign != c.callsign,
        builder: (context, state) => TextFormField(
          initialValue: state.callsign,
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
      );
}

class _DateOnInput extends StatefulWidget {
  const _DateOnInput({Key? key}) : super(key: key);

  @override
  State<_DateOnInput> createState() => _DateOnInputState();
}

class _DateOnInputState extends State<_DateOnInput> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = context.read<NewLogEntryCubit>().state.dateOnString;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<NewLogEntryCubit, NewLogEntryState>(
        listener: (context, state) {
          if (state.dateOnString.replaceAll('-', '') !=
              _controller.text.replaceAll(RegExp(r'\D+'), '')) {
            _controller.text = state.dateOnString;
          }
        },
        child: TextFormField(
          controller: _controller,
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

class _TimeOnInput extends StatefulWidget {
  const _TimeOnInput({Key? key}) : super(key: key);

  @override
  State<_TimeOnInput> createState() => _TimeOnInputState();
}

class _TimeOnInputState extends State<_TimeOnInput> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = context.read<NewLogEntryCubit>().state.timeOnString;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<NewLogEntryCubit, NewLogEntryState>(
        listener: (context, state) {
          if (state.timeOnString != _controller.text.padLeft(4, '0')) {
            _controller.text = state.timeOnString;
          }
        },
        child: TextFormField(
          controller: _controller,
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
          decoration: const InputDecoration(labelText: 'Band'),
          value: state.band,
          onChanged: context.read<NewLogEntryCubit>().setBand,
          items: Band.values
              .map((e) => DropdownMenuItem(
                    child: Text(e.label),
                    value: e,
                  ))
              .toList(),
        ),
      );
}

class _FrequencyInput extends StatefulWidget {
  const _FrequencyInput({Key? key}) : super(key: key);

  @override
  State<_FrequencyInput> createState() => _FrequencyInputState();
}

class _FrequencyInputState extends State<_FrequencyInput> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = context.read<NewLogEntryCubit>().state.freqMhz;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<NewLogEntryCubit, NewLogEntryState>(
        listenWhen: (prev, curr) => prev.frequency != curr.frequency,
        listener: (context, state) {
          if (state.frequency !=
              NewLogEntryCubit.tryParseFreq(_controller.text)) {
            _controller.text = state.freqMhz;
          }
        },
        child: TextFormField(
          controller: _controller,
          inputFormatters: [DoubleTextFormatter()],
          onChanged: context.read<NewLogEntryCubit>().setFreq,
          decoration: const InputDecoration(
            labelText: 'Frequency',
            suffixText: 'MHz',
          ),
        ),
      );
}

class _BandRxInput extends StatelessWidget {
  const _BandRxInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NewLogEntryCubit, NewLogEntryState>(
        buildWhen: (prev, curr) => prev.bandRx != curr.bandRx,
        builder: (context, state) => DropdownButtonFormField<Band>(
          decoration: const InputDecoration(labelText: 'Receive Band'),
          value: state.bandRx,
          onChanged: context.read<NewLogEntryCubit>().setBandRx,
          items: Band.values
              .map((e) => DropdownMenuItem(
                    child: Text(e.label),
                    value: e,
                  ))
              .toList(),
        ),
      );
}

class _FrequencyRxInput extends StatefulWidget {
  const _FrequencyRxInput({Key? key}) : super(key: key);

  @override
  State<_FrequencyRxInput> createState() => _FrequencyRxInputState();
}

class _FrequencyRxInputState extends State<_FrequencyRxInput> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = context.read<NewLogEntryCubit>().state.freqMhz;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<NewLogEntryCubit, NewLogEntryState>(
        listenWhen: (prev, curr) => prev.frequencyRx != curr.frequencyRx,
        listener: (context, state) {
          if (state.frequencyRx !=
              NewLogEntryCubit.tryParseFreq(_controller.text)) {
            _controller.text = state.freqRxMhz;
          }
        },
        child: TextFormField(
          controller: _controller,
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
          decoration: const InputDecoration(labelText: 'Mode'),
          value: state.mode,
          onChanged: context.read<NewLogEntryCubit>().setMode,
          items: ModeUtil.topModes
              .map((e) => DropdownMenuItem(
                    child: Text(e.name.toUpperCase()),
                    value: e,
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
  Widget build(BuildContext context) =>
      BlocBuilder<NewLogEntryCubit, NewLogEntryState>(
        builder: (context, state) => TextFormField(
          initialValue: '${state.power ?? ''}',
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'\d'))],
          onChanged: context.read<NewLogEntryCubit>().setPower,
          decoration: const InputDecoration(
            labelText: 'Power',
            suffixText: 'W',
          ),
        ),
      );
}

class _RstSentInput extends StatefulWidget {
  const _RstSentInput({Key? key}) : super(key: key);

  @override
  State<_RstSentInput> createState() => _RstSentInputState();
}

class _RstSentInputState extends State<_RstSentInput> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = context.read<NewLogEntryCubit>().state.rstSent;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<NewLogEntryCubit, NewLogEntryState>(
        listenWhen: (prev, curr) => prev.rstSent != curr.rstSent,
        listener: (context, state) {
          if (state.rstSent != _controller.text) {
            _controller.text = state.rstSent;
          }
        },
        child: TextFormField(
          controller: _controller,
          onChanged: context.read<NewLogEntryCubit>().setRstSent,
          decoration: const InputDecoration(
            labelText: 'RST Sent',
          ),
        ),
      );
}

class _RstSentButton extends StatelessWidget {
  const _RstSentButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NewLogEntryCubit, NewLogEntryState>(
        builder: (context, state) {
          final def = state.mode.defaultReport;
          if (def == null) return const SizedBox.shrink();

          return ElevatedButton(
            onPressed: () => context.read<NewLogEntryCubit>().setRstSent(def),
            child: Text(def),
          );
        },
      );
}

class _RstRecvInput extends StatefulWidget {
  const _RstRecvInput({Key? key}) : super(key: key);

  @override
  State<_RstRecvInput> createState() => _RstRecvInputState();
}

class _RstRecvInputState extends State<_RstRecvInput> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = context.read<NewLogEntryCubit>().state.rstReceived;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<NewLogEntryCubit, NewLogEntryState>(
        listenWhen: (prev, curr) => prev.rstReceived != curr.rstReceived,
        listener: (context, state) {
          if (state.rstReceived != _controller.text) {
            _controller.text = state.rstReceived;
          }
        },
        child: TextFormField(
          controller: _controller,
          onChanged: context.read<NewLogEntryCubit>().setRstRecv,
          decoration: const InputDecoration(
            labelText: 'RST Received',
          ),
        ),
      );
}

class _RstRecvButton extends StatelessWidget {
  const _RstRecvButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NewLogEntryCubit, NewLogEntryState>(
        builder: (context, state) {
          final def = state.mode.defaultReport;
          if (def == null) return const SizedBox.shrink();

          return ElevatedButton(
            onPressed: () => context.read<NewLogEntryCubit>().setRstRecv(def),
            child: Text(def),
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
        onPressed: () {},
        child: const Text('Submit'),
      );
}
