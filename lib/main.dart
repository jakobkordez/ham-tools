import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/app.dart';
import 'src/repository/local_repository.dart';
import 'src/repository/repository.dart';
import 'src/repository/server_repository.dart';

Future<void> main() async {
  final localRepo = await LocalRepository.init();
  final serverRepo = await ServerRepository.init(localRepository: localRepo);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Repository>.value(value: serverRepo),
        RepositoryProvider<ServerRepository>.value(value: serverRepo),
      ],
      child: const App(),
    ),
  );
}
