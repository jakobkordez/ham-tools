enum CabrilloCategoryOperator {
  // SINGLE-OP
  singleOp,
  // MULTI-OP
  multiOp,
  // CHECKLOG
  checkLog,
}

extension on CabrilloCategoryOperator {
  String get name {
    switch (this) {
      case CabrilloCategoryOperator.singleOp:
        return 'SINGLE-OP';
      case CabrilloCategoryOperator.multiOp:
        return 'MULTI-OP';
      case CabrilloCategoryOperator.checkLog:
        return 'CHECKLOG';
    }
  }
}
