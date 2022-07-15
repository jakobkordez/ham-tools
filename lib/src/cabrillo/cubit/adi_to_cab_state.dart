part of 'adi_to_cab_cubit.dart';

class AdiToCabState extends Equatable {
  final String adiFile;
  final Key adiFormKey;

  AdiToCabState({
    this.adiFile = '',
    Key? adiFormKey,
  }) : adiFormKey = adiFormKey ?? UniqueKey();

  AdiToCabState copyWith({
    String? adiFile,
    Key? adiFormKey,
  }) {
    return AdiToCabState(
      adiFile: adiFile ?? this.adiFile,
      adiFormKey: adiFormKey ?? this.adiFormKey,
    );
  }

  @override
  List<Object> get props => [adiFile, adiFormKey];
}
