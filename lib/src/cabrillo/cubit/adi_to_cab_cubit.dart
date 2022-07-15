import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'adi_to_cab_state.dart';

class AdiToCabCubit extends Cubit<AdiToCabState> {
  AdiToCabCubit() : super(AdiToCabState());

  void updateAdiFile(String adiFile, [bool force = false]) {
    emit(state.copyWith(
      adiFile: adiFile,
      adiFormKey: force ? UniqueKey() : null,
    ));
  }
}
