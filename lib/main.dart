import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/app.dart';
import 'src/repository/local_repository.dart';
import 'src/repository/repository.dart';

Future<void> main() async {
  final repository = await LocalRepository.init();

  runApp(
    RepositoryProvider<Repository>.value(
      value: repository,
      child: const App(),
    ),
  );
}
