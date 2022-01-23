import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ham_tools/src/log/bloc/log_bloc.dart';
import 'package:ham_tools/src/log/log_screen.dart';

class App extends StatelessWidget {
  final LogBloc logBloc;

  const App({Key? key, required this.logBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider.value(
        value: logBloc,
        child: const MaterialApp(
          title: 'Ham tools',
          home: LogScreen(),
        ),
      );
}
