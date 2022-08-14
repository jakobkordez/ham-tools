import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FieldController<B extends StateStreamable<S>, S> extends StatefulWidget {
  final String Function(S state) getValue;
  final Widget Function(BuildContext context, TextEditingController controller)
      builder;

  const FieldController({
    super.key,
    required this.getValue,
    required this.builder,
  });

  @override
  State<FieldController> createState() => _FieldControllerState<B, S>();
}

class _FieldControllerState<B extends StateStreamable<S>, S>
    extends State<FieldController<B, S>> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.getValue(context.read<B>().state);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocListener<B, S>(
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
