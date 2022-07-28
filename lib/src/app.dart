import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'log/bloc/log_bloc.dart';
import 'log/log_screen.dart';
import 'repository/repository.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) =>
            LogBloc(context.read<Repository>())..add(LogFetched()),
        child: MaterialApp(
          title: 'Ham tools',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
                    // primarySwatch: Colors.deepOrange,
                    // backgroundColor: const Color(0xffffb28f),
                    )
                .copyWith(
                    // primary: const Color(0xfff34d00),
                    ),
          ),
          home: const LogScreen(),
        ),
      );
}
