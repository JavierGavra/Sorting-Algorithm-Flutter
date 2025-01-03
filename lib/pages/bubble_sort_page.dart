import 'package:flutter/material.dart';
import 'package:sorting_algorithm_visualize/config/config.dart';
import 'package:sorting_algorithm_visualize/model/list_model.dart';
import 'package:sorting_algorithm_visualize/model/list_utils.dart';

class BubbleSortPage extends StatefulWidget {
  const BubbleSortPage({super.key, required this.arrayLength, required this.title});

  final int arrayLength;
  final String title;

  @override
  State<BubbleSortPage> createState() => _BubbleSortPageState();
}

class _BubbleSortPageState extends State<BubbleSortPage> {
  List<ListItemModel> array = [];
  int delay = 500;
  String status = "Ready";

  final ValueNotifier<bool> _isSorting = ValueNotifier<bool>(false);

  Future<void> checkIsSorted() async {
    setState(() {
      status = "Checking...";
      array[0].status = ListItemStatus.correctPosition;
    });

    int compareDelay = (Config.checkIsSortedTime~/array.length)~/2;
    for (int i = 1; i < array.length; i++) {
      setState(() => array[i].status = ListItemStatus.selected);
      await Future.delayed(Duration(microseconds: compareDelay));

      if (array[i - 1].number > array[i].number) {
        setState(() => status = "Not Sorted");
        ListUtils.backToNormal(array);
        return;
      }

      setState(() => array[i].status = ListItemStatus.correctPosition);
      await Future.delayed(Duration(microseconds: compareDelay));
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
                      items: Config.delayList.map<DropdownMenuItem<int>>((int value) {
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
                        onPressed: value? null : sort,
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

  Future<void> sort() async {
    _isSorting.value = true;
    setState(() => status = "Sorting...");

    for (int i = 0; i < array.length; i++) {
      for (int j = 0; j < array.length - i - 1; j++) {

        setState(() {
          array[j].status = ListItemStatus.selected;
          array[j + 1].status = ListItemStatus.selected;
        });
        await Future.delayed(Duration(microseconds: delay));

        if (array[j].number > array[j + 1].number) {
          int temp = array[j + 1].number;
          array[j + 1].number = array[j].number;
          array[j].number = temp;

          setState(() {});
          await Future.delayed(Duration(microseconds: delay));
        }

        setState(() {
          array[j].status = ListItemStatus.normal;
          array[j + 1].status = ListItemStatus.normal;
        });
      }
    }

    await checkIsSorted();
    _isSorting.value = false;
  }
}
