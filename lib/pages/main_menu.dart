import 'package:flutter/material.dart';
import 'package:sorting_algorithm_visualize/model/sorting_algorithm_list_model.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key});

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  final TextEditingController editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text("Sorting Algorithm Visualize"),
            backgroundColor: color.primary,
            foregroundColor: color.onPrimary,
            snap: true,
            floating: true,
          ),
          SliverToBoxAdapter(
            child: GridView.builder(
              itemCount: SortingAlgorithmListModel.list.length,
              shrinkWrap: true,
              padding: const EdgeInsets.all(20),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 2.4
              ),
              itemBuilder: (context, index) {
                final SortingAlgorithmModel model = SortingAlgorithmListModel.list[index];

                return Card(
                  color: model.cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: SizedBox(
                                width: 180,
                                child: TextField(
                                  controller: editController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Define array length",
                                      hintText: "Default: 50"
                                  ),
                                ),
                              ),
                              actions: [
                                OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel"),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    Widget page = SortingAlgorithmListModel.page(
                                      model.title,
                                      editController.text.isEmpty
                                        ? 50
                                        : int.parse(editController.text)
                                    )!;
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => page)
                                    );
                                  },
                                  child: const Text("Continue"),
                                ),
                              ],
                            );
                          },
                      );
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: Center(
                      child: Text(
                        model.title,
                        style: TextStyle(
                          fontSize: 16,
                          color: model.titleColor,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ),
                  )
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
