import 'dart:math';
import 'package:sorting_algorithm_visualize/model/list_model.dart';

class ListUtils {
  static void shuffleList(List<ListItemModel> list) {
    final random = Random();
    for (int i = list.length - 1; i > 0; i--) {
      int j = random.nextInt(i + 1); // Random index from 0 to i
      final temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }
  }

  static void backToNormal(List<ListItemModel> list) {
    for (int i = 0; i < list.length; i++) {
      list[i].status = ListItemStatus.normal;
    }
  }
}