import 'package:flutter/material.dart';
import 'package:sudoku_dart/sudoku_dart.dart';
import 'package:sudoku_game/models/matrix_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SudokuApp(),
    );
  }
}

class SudokuApp extends StatefulWidget {
  const SudokuApp({super.key});

  @override
  State<SudokuApp> createState() => _SudokuAppState();
}

class _SudokuAppState extends State<SudokuApp> {
  late Sudoku sudoku;
  int selectedIndex = 0;
  int selectedColumn = 0;
  int selectedRow = 0;
  int selectedGroup = 0;
  List<SudokuMatix> puzzle = [];
  bool isNoteMode = false;
  int? selectedValue;
  @override
  void initState() {
    init();
    super.initState();
  }

  void init({Level level = Level.easy}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sudoku = Sudoku.generate(level);
      puzzle = sudoku.puzzle.map((e) {
        return SudokuMatix(value: e, isDefault: e != -1);
      }).toList();
      selectedIndex = 0;
      selectedColumn = 0;
      selectedRow = 0;
      selectedGroup = 0;
      setState(() {});
    });
  }

  void selectCell({required int index, required int row, required int col}) {
    selectedIndex = index;
    selectedColumn = col;
    selectedRow = row;
    selectedGroup = (row ~/ 3) * 3 + col ~/ 3;
    final selected = puzzle[selectedIndex].value;
    selectedValue = selected == -1 ? null : selected;
    setState(() {});
  }

  void changeCellValue(int value) {
    if (isNoteMode && value != -1) {
      puzzle[selectedIndex].noteNums.contains(value)
          ? puzzle[selectedIndex].noteNums.remove(value)
          : puzzle[selectedIndex].noteNums.add(value);
    } else {
      puzzle[selectedIndex] = puzzle[selectedIndex].copyWith(value: value);
    }
    setState(() {});
  }

  void changeNoteMode() {
    isNoteMode = !isNoteMode;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, boxConstraints) {
        return Wrap(
          children: [sudokuGrid(), actionGrid(boxConstraints, context)],
        );
      }),
    );
  }

  ConstrainedBox actionGrid(
      BoxConstraints boxConstraints, BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: boxConstraints.maxWidth > 1250
            ? MediaQuery.of(context).size.width * 0.3
            : 300,
      ),
      child: Column(
        //keypaf
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      init();
                    },
                    child: const Text('New Game'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: solve,
                    child: const Text('Solve'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      changeNoteMode();
                    },
                    child: Text(isNoteMode ? 'Note Mode' : 'Normal Mode'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      changeCellValue(-1);
                    },
                    child: const Text('Clear'),
                  ),
                ),
              ],
            ),
          ),
          GridView.builder(
              shrinkWrap: true,
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => changeCellValue(index + 1),
                    child: Text('${index + 1}'),
                  ),
                );
              })
        ],
      ),
    );
  }

  ConstrainedBox sudokuGrid() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 750),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: GridView.builder(
              shrinkWrap: true,
              itemCount: puzzle.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 9),
              itemBuilder: (context, index) {
                int row = index ~/ 9;
                int col = index % 9;
                final value = puzzle[index];
                return GestureDetector(
                  onTap: () => selectCell(
                    index: index,
                    row: row,
                    col: col,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: selectedIndex == index
                          ? Colors.blue.withOpacity(0.5)
                          : selectedColumn == col ||
                                  selectedRow == row ||
                                  selectedGroup == (row ~/ 3) * 3 + col ~/ 3
                              ? Colors.blue.withOpacity(0.2)
                              : selectedValue == value.value
                                  ? Colors.blueAccent.withOpacity(.3)
                                  : Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          width: row % 3 == 2 && row != 8 ? 3.0 : 1,
                          color: Colors.black,
                        ),
                        right: BorderSide(
                          width: col % 3 == 2 && col != 8 ? 3.0 : 1,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    child: Center(
                      child: value.value != -1
                          ? Text(
                              value.value == -1 ? '' : value.value.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                color: value.isDefault
                                    ? Colors.black
                                    : Colors.blue,
                              ),
                            )
                          : GridView.builder(
                              itemCount: 9,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemBuilder: (context, index) {
                                return Center(
                                  child: Text(
                                    value.noteNums.contains(index + 1)
                                        ? (index + 1).toString()
                                        : '',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  void solve() {
    puzzle = sudoku.solution.map((e) {
      return SudokuMatix(value: e, isDefault: e != -1);
    }).toList();
    setState(() {});
  }
}
