import 'package:flutter/material.dart';
import 'package:sorting_algorithm_visualize/model/list_model.dart';
import 'package:sorting_algorithm_visualize/model/list_utils.dart';

class QuickSortPage extends StatefulWidget {
  const QuickSortPage({super.key, required this.arrayLength, required this.title});

  final int arrayLength;
  final String title;

  @override
  State<QuickSortPage> createState() => _QuickSortPageState();
}

class _QuickSortPageState extends State<QuickSortPage> {
  List<ListItemModel> array = [];

  final List<int> delayList = [500000, 100000, 50000, 10000, 5000, 3500, 2000, 1500, 1000, 750, 500, 250, 100];
  int delay = 500;
  String status = "Ready";

  final ValueNotifier<bool> _isSorting = ValueNotifier<bool>(false);

  Future<void> checkIsSorted() async {
    setState(() {
      status = "Checking...";
      array[0].status = ListItemStatus.correctPosition;
    });
    for (int i = 1; i < array.length; i++) {
      setState(() => array[i].status = ListItemStatus.selected);
      await Future.delayed(const Duration(milliseconds: 10));

      if (array[i - 1].number > array[i].number) {
        setState(() => status = "Not Sorted");
        ListUtils.backToNormal(array);
        return;
      }

      setState(() => array[i].status = ListItemStatus.correctPosition);
      await Future.delayed(const Duration(milliseconds: 10));
    }

    ListUtils.backToNormal(array);
    setState(() => status = "Sorted");
  }

  @override
  void initState() {
    array = List.generate(widget.arrayLength, (index) => ListItemModel(index + 1));
    ListUtils.shuffleList(array);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final Size screenSize = MediaQuery.sizeOf(context);

    final double maxRectHeight = screenSize.height * 0.75;
    final double rectPadding = (screenSize.width / array.length) * 0.025;
    final double rectWidth = (screenSize.width / array.length) - (rectPadding * 2);

    return Scaffold(
        backgroundColor: color.surface,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: rectPadding * 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(
                  array.length, (index) {
                  return Container(
                    height: maxRectHeight / array.length * array[index].number,
                    width: rectWidth,
                    color: array[index].status == ListItemStatus.selected
                        ? Colors.red
                        : array[index].status == ListItemStatus.selected2
                        ? Colors.blue
                        : array[index].status == ListItemStatus.correctPosition
                        ? Colors.green
                        : color.onSurface,
                  );
                },
                ),
              ),
            ),
            Container(
              height: 60,
              width: screenSize.width,
              color: color.secondaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ValueListenableBuilder(
                valueListenable: _isSorting,
                builder: (context, value, child) {
                  return Row(
                    children: [
                      const BackButton(),
                      const SizedBox(width: 8),
                      Text(
                        widget.title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        status,
                        style: TextStyle(color: color.tertiary),
                      ),
                      const Spacer(),
                      DropdownButton<int>(
                        value: delay,
                        icon: const Icon(Icons.timelapse_outlined),
                        underline: Container(height: 2, color: color.primary),
                        onChanged: (int? value) => setState(() => delay = value!),
                        items: delayList.map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text("${value/1000} ms"),
                          );
                        }).toList(),
                      ),
                      const SizedBox(width: 30),
                      SizedBox(
                        width: 120,
                        child: OutlinedButton(
                            onPressed: value
                                ? null
                                : () => setState(() => ListUtils.shuffleList(array)),
                            child: const Text("Shuffle")
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 120,
                        child: FilledButton(
                            onPressed: value? null : () => sort(array),
                            child: const Text("Start")
                        ),
                      )
                    ],
                  );
                },
              ),
            )
          ],
        )
    );
  }


  // === SORTING ALGORITHM ===


  Future<void> sort(List<ListItemModel> array) async {
    _isSorting.value = true;
    setState(() => status = "Sorting...");

    await quickSort(array, 0, array.length - 1);

    await checkIsSorted();
    _isSorting.value = false;
  }

  Future<void> quickSort(List<ListItemModel> array, int start, int end) async {
    if (start < end) {
      int pivot = await partition(array, start, end).then((value) => value);

      await quickSort(array, start, pivot - 1); // Left
      await quickSort(array, pivot + 1, end); // Right
    }
  }

  Future<int> partition(List<ListItemModel> array, int start, int end) async {
    int pivot = array[end].number;
    int i = start - 1;

    setState(() => array[end].status = ListItemStatus.correctPosition);

    for (int j = start; j < end + 1; j++) {
      setState(() => array[j].status = ListItemStatus.selected);
      if (i >= 0) setState(() => array[i].status = ListItemStatus.selected2);
      await Future.delayed(Duration(microseconds: delay));

      if (array[j].number <= pivot) {
        i++;

        if (i > 0) setState(() => array[i - 1].status = ListItemStatus.normal);
        setState(() => array[i].status = ListItemStatus.selected2);
        await Future.delayed(Duration(microseconds: delay));

        if (array[i].number <= array[j].number) {
          setState(() => array[i].status = ListItemStatus.normal);
          setState(() => array[j].status = ListItemStatus.normal);
          continue;
        }

        int temp = array[j].number;
        array[j].number = array[i].number;
        array[i].number = temp;

        setState(() {
          array[j].status = ListItemStatus.selected2;
          array[i].status = ListItemStatus.selected;
        });
        await Future.delayed(Duration(microseconds: delay));

        setState(() {
          array[j].status = ListItemStatus.normal;
          array[i].status = ListItemStatus.normal;
        });
      }

      setState(() => array[j].status = ListItemStatus.normal);
      if (i >= 0) setState(() => array[i].status = ListItemStatus.normal);
    }

    setState(() => array[i].status = ListItemStatus.normal);
    return i;
  }
}
