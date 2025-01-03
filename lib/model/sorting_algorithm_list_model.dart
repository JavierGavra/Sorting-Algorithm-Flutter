import 'package:flutter/material.dart';
import 'package:sorting_algorithm_visualize/pages/bubble_sort_page.dart';
import 'package:sorting_algorithm_visualize/pages/insertion_sort_page.dart';
import 'package:sorting_algorithm_visualize/pages/quick_sort_page.dart';
import 'package:sorting_algorithm_visualize/pages/selection_sort_page.dart';

class SortingAlgorithmListModel {
  static final List<SortingAlgorithmModel> list = [
    const SortingAlgorithmModel(
      title: "Bubble Sort",
      cardColor: Color(0xFFC2E3FF),
      titleColor: Colors.black,
    ),
    const SortingAlgorithmModel(
      title: "Insertion Sort",
      cardColor: Color(0xFFFFE3C2),
      titleColor: Colors.black,
    ),
    const SortingAlgorithmModel(
      title: "Quick Sort",
      cardColor: Color(0xFFFFC2C2),
      titleColor: Colors.black,
    ),
    const SortingAlgorithmModel(
      title: "Selection Sort",
      cardColor: Color(0xFFC2FFD5),
      titleColor: Colors.black,
    ),
  ];

  static Widget? page(String title, int arrayLength) {
    if (title == "Bubble Sort") {
      return BubbleSortPage(title: title, arrayLength: arrayLength);
    } else if (title == "Selection Sort") {
      return SelectionSortPage(title: title, arrayLength: arrayLength);
    } else if (title == "Quick Sort") {
      return QuickSortPage(title: title, arrayLength: arrayLength);
    } else if (title == "Insertion Sort") {
      return InsertionSortPage(title: title, arrayLength: arrayLength);
    } else {
      return null;
    }
  }
}

class SortingAlgorithmModel {
  final String title;
  final Color cardColor;
  final Color titleColor;

  const SortingAlgorithmModel({
    required this.title,
    required this.cardColor,
    required this.titleColor,
  });
}