import 'package:flutter/material.dart';
import 'Constants.dart';
import 'Utils.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> numbers;
  List<int> pointers = [];
  int n;
  String procedureString;
  String selectedAlgorithm = shortingAlgoList[0].title;
  bool disabled = false, isCancelled = false;

  @override
  void initState() {
    super.initState();
    numbers = new List<int>.generate(10, (i) => i + 1);
    n = numbers.length;
    shuffle();
  }

  void shuffle() {
    setState(() {
      procedureString = 'Press below Sort button to start sorting';
      numbers.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AppBar(
              title: Text('Sorting Visualizer', style: TextStyle(color: Colors.black, decoration: TextDecoration.underline, decorationStyle: TextDecorationStyle.double),),
              centerTitle: true,
              backgroundColor: primary,
              elevation: 0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20, bottom: 25),
              child: ShortingAlgorithmsList(
                onTap: (selected) {
                  setState(() {
                    selectedAlgorithm = selected;
                  });

                },
              ),
            ),
            ChartWidget(
              numbers: numbers,
              currentNumbers: pointers,
            ),
            BottomPointer(
              lenght: numbers.length,
              pointers: pointers,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    procedureString,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SortAndShuffleButtons(),
          ],
        ),
      ),
    );
  }

  Widget SortAndShuffleButtons() {
    return Padding(
      padding: EdgeInsets.only(bottom: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FloatingActionButton.extended(
            backgroundColor: primaryDark,
            label: Text(disabled ? '     Cancel          ' : '${selectedAlgorithm}'),
            icon: Icon(disabled ? Icons.cancel : Icons.play_circle_outline),
            onPressed: () {
              if (disabled) {
                setState(() {
                  isCancelled = true;
                });
              } else
                startSorting();
            },
          ),
          FloatingActionButton.extended(
            backgroundColor: disabled ? Colors.black : primaryDark,
            icon: Icon(Icons.shuffle),
            onPressed: () {
              disabled ? null : shuffle();
            },
            label: Text('   Shuffle       '),
          ),
        ],
      ),
    );
  }

  void startSorting() {
    switch (selectedAlgorithm) {
      case selectionSort:
        selectionSortAlgo();
        break;

      case bubbleSort:
        bubbleSortAlgo();
        break;

      case insertionSort:
        insertionSortAlgo();
        break;

      default:
        break;
    }
  }

  void selectionSortAlgo() async {
    preStartSorting();

    for (int i = 0; i < n - 1; i++) {
      if (isCancelled) break;

      int minIdx = i;
      setProcedureText('Finding minimun...');
      for (int j = i + 1; j < n; j++) {
        if (isCancelled) break;
        updatePointers([i, j]);
        await Future.delayed(Duration(milliseconds: 350));
        if (numbers[j] < numbers[minIdx]) minIdx = j;
      }

      updatePointers([minIdx, i]);
      setProcedureText(
          'Swapping minimun element ${numbers[minIdx]} with ${numbers[i]}');
      await Future.delayed(Duration(milliseconds: 1500));
      swap(numbers, i, minIdx);
    }

    isCancelled ? cancelSorting() : finishSorting();
  }

  void bubbleSortAlgo() async {
    preStartSorting();
    int i, step;
    for (step = 0; step < n; step++) {
      if (isCancelled) break;
      for (i = 0; i < n - step - 1; i++) {
        if (isCancelled) break;
        updatePointers([i, i + 1]);
        setProcedureText('Is ${numbers[i]} > ${numbers[i + 1]} ?');
        await Future.delayed(Duration(milliseconds: 1500));

        if (numbers[i] > numbers[i + 1]) {
          swap(numbers, i, i + 1);
          setProcedureText('Yes, so swap these');
        } else {
          setProcedureText('No, no need to swap');
        }

        await Future.delayed(Duration(seconds: 1));
      }
    }

    isCancelled ? cancelSorting() : finishSorting();
  }

  void insertionSortAlgo() async {
    preStartSorting();
    int i, key, j;
    updatePointers([0]);
    setProcedureText('Assume 1st number is sorted');
    await Future.delayed(Duration(seconds: 1));

    for (i = 1; i < n; i++) {
      if (isCancelled) break;
      updatePointers([i]);
      setProcedureText('Take ${numbers[i]} as key element');
      await Future.delayed(Duration(milliseconds: 1500));
      key = numbers[i];
      j = i - 1;

      while (j >= 0 && numbers[j] > key) {
        if (isCancelled) break;
        updatePointers([numbers.indexOf(key), j]);
        setProcedureText(
            'Since $key < ${numbers[j]}, so insert key 1 place before');
        await Future.delayed(Duration(milliseconds: 1500));
        swap(numbers, j + 1, j);
        updatePointers([numbers.indexOf(key)]);
        await Future.delayed(Duration(seconds: 1));
        j--;
      }
      numbers[j + 1] = key;
    }

    isCancelled ? cancelSorting() : finishSorting();
  }

  void preStartSorting() {
    setState(() {
      isCancelled = false;
      disabled = true;
    });
  }

  void updatePointers(runningPointers) {
    setState(() {
      pointers = runningPointers;
    });
  }

  void setProcedureText(procedure) {
    setState(() {
      procedureString = procedure;
    });
  }

  void swap(numbers, i, j) {
    int temp = numbers[i];
    numbers[i] = numbers[j];
    numbers[j] = temp;
  }

  void cancelSorting() {
    setState(() {
      procedureString = 'Sorting Cancelled !!';
      disabled = false;
    });
  }

  void finishSorting() {
    setState(() {
      procedureString = 'Yeee !! Sorting finished';
      disabled = false;
    });
  }
}
