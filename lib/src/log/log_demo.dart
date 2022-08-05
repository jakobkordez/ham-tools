import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/local_repository.dart';
import '../repository/repository.dart';
import 'bloc/log_bloc.dart';
import 'log_screen.dart';

class LogDemo extends StatelessWidget {
  const LogDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => FutureBuilder<Repository>(
        future: LocalRepository.init(),
        builder: (context, snapshot) => snapshot.data != null
            ? RepositoryProvider<Repository>.value(
                value: snapshot.data!,
                child: BlocProvider(
                  create: (context) =>
                      LogBloc(context.read<Repository>())..add(LogFetched()),
                  child: const LogScreen(),
                ),
              )
            : const Center(child: LinearProgressIndicator()),
      );
}
