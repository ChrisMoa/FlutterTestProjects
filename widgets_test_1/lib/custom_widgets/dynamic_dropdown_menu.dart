import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class IListable<T> {
  void addItem(T item);

  void removeItem(T item);
}

// StateNotifier for managing the list of items
class ListNotifier<T> extends StateNotifier<List<T>> implements IListable<T> {
  ListNotifier() : super([]);

  @override
  void addItem(T item) {
    state = [...state, item];
  }

  @override
  void removeItem(T item) {
    state = state.where((curElement) => curElement != item).toList();
  }
}

class DropdownMenuExample<T> extends ConsumerStatefulWidget {
  const DropdownMenuExample({super.key, required this.itemListProvider, required this.selectedItemProvider, required this.dropdownMenuItemChild});
  final StateNotifierProvider<ListNotifier, List<T>> itemListProvider;
  final StateProvider<T?> selectedItemProvider;
  final Widget dropdownMenuItemChild;

  @override
  ConsumerState<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState<T> extends ConsumerState<DropdownMenuExample> {
  T? selectedItem;

  @override
  Widget build(BuildContext context) {
    assert(ref.watch(widget.itemListProvider) is List<T>, 'The item list must be a List');
    final list = (ref.watch(widget.itemListProvider) as List<T>);
    selectedItem = selectedItem ?? list.first;

    return Column(
      children: [
        DropdownButton<T>(
          hint: const Text('Select an item'),
          value: selectedItem,
          onChanged: (T? newValue) {
            setState(() {
              selectedItem = newValue;
            });
            ref.read(widget.selectedItemProvider.notifier).state = newValue;
          },
          items: list.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: widget.dropdownMenuItemChild,
              ),
            );
          }).toList(),
        ),
        // ElevatedButton(
        //   onPressed: () {
        //     // Add a new item when the button is pressed
        //     assert(ref.read(widget.selectedItemProvider.notifier) is IListable, 'not compatible types of notifier');
        //     (ref.read(widget.selectedItemProvider.notifier) as IListable).addItem(
        //       Item(name: 'New Item', icon: Icons.new_releases),
        //     );
        //   },
        //   child: const Text('Add Item'),
        // ),
      ],
    );
  }
}
