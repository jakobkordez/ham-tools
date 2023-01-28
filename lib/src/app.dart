import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/settings_cubit.dart';
import 'log/bloc/log_bloc.dart';
import 'log/log_screen.dart';
import 'repository/repository.dart';
import 'settings/profiles/cubit/profiles_cubit.dart';
import 'settings/settings_screen.dart';

const _inputDecorationTheme = InputDecorationTheme(
  filled: true,
  isDense: true,
);

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SettingsCubit(),
          ),
          BlocProvider(
            create: (context) => LogBloc(context.read<Repository>()),
          ),
          BlocProvider(
            create: (context) => ProfilesCubit(context.read<Repository>()),
          ),
        ],
        child: BlocBuilder<SettingsCubit, SettingsState>(
          buildWhen: (previous, current) =>
              previous.themeMode != current.themeMode,
          builder: (context, state) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Ham tools',
            initialRoute: '/log',
            routes: <String, WidgetBuilder>{
              '/log': (_) => const LogScreen(),
              '/settings': (_) => const SettingsScreen(),
            },
            themeMode: state.themeMode,
            theme: ThemeData(
              inputDecorationTheme: _inputDecorationTheme,
            ),
            darkTheme: ThemeData(
              inputDecorationTheme: _inputDecorationTheme,
              colorScheme: ColorScheme.dark(
                primary: Colors.purple.shade300,
                secondary: Colors.purple.shade300,
              ),
            ),
          ),
        ),
      );
}
