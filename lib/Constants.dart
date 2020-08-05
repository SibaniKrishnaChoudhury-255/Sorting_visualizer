
import 'package:flutter/material.dart';
import 'Models.dart';

const Color primary = Colors.lightBlue;
const Color primaryDark = Color(0xff470938);
const Color accent = Color(0xffffffff);

const String selectionSort = 'Selection Sort';
const String bubbleSort = 'Bubble Sort';
const String insertionSort = 'Insertion Sort';

final List<SortingModel> shortingAlgoList = [
  SortingModel(
      title: selectionSort,
      complexity: 'n^2'
  ),

  SortingModel(
      title: bubbleSort,
      complexity: 'n^2'
  ),

  SortingModel(
      title: insertionSort,
      complexity: 'n^2'
  ),

];