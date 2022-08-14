import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'log/bloc/log_bloc.dart';
import 'log/log_screen.dart';
import 'repository/repository.dart';
import 'settings/profiles/cubit/profiles_cubit.dart';
import 'settings/settings_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LogBloc(context.read<Repository>()),
          ),
          BlocProvider(
            create: (context) => ProfilesCubit(context.read<Repository>()),
          ),
        ],
        child: MaterialApp(
          title: 'Ham tools',
          initialRoute: '/log',
          routes: <String, WidgetBuilder>{
            '/log': (_) => const LogScreen(),
            '/settings': (_) => const SettingsScreen(),
          },
          theme: ThemeData(
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              isDense: true,
            ),
          ),
        ),
      );
}
