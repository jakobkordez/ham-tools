import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ham_tools/src/app.dart';
import 'package:ham_tools/src/repository/local_repository.dart';
import 'package:ham_tools/src/repository/repository.dart';

Future<void> main() async {
  final repository = await LocalRepository.init();

  runApp(
    RepositoryProvider<Repository>.value(
      value: repository,
      child: const App(),
    ),
  );
}
