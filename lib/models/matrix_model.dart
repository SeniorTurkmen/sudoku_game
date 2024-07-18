class SudokuMatix {
  final int value;
  final bool isDefault;
  List<int> noteNums = [];

  SudokuMatix({required this.value, required this.isDefault});

  SudokuMatix copyWith({required int value}) {
    if (isDefault) {
      return this;
    }
    var model = SudokuMatix(value: value, isDefault: isDefault);
    return model..noteNums = noteNums;
  }

  @override
  String toString() {
    return '''
    SudokuMatix(
      value: $value,
      isDefault: $isDefault,
    )''';
  }
}
