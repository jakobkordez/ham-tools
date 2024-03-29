import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
