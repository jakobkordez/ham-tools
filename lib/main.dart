import 'package:flutter/material.dart';
import 'package:ham_tools/src/app.dart';
import 'package:ham_tools/src/log/bloc/log_bloc.dart';
import 'package:ham_tools/src/repository/mock_repository.dart';
import 'package:ham_tools/src/repository/repository.dart';

void main() {
  final Repository repository = MockRepository();

  final logBloc = LogBloc(repository)..add(LogFetched());

  runApp(App(logBloc: logBloc));
}
