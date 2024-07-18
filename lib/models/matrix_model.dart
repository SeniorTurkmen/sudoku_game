class SudokuMatix {
  final int value;
  final bool isDefault;
  final List<int> noteNums;

  SudokuMatix(
      {required this.value, required this.isDefault, this.noteNums = const []});

  SudokuMatix copyWith({required int value}) {
    if (isDefault) {
      return this;
    }
    return SudokuMatix(value: value, isDefault: isDefault, noteNums: noteNums);
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
