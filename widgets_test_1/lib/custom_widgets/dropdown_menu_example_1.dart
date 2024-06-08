import 'package:flutter/material.dart';

class DropdownMenuExample extends StatefulWidget {
  const DropdownMenuExample({super.key, required this.list});
  final List<Item> list;

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  Item? selectedItem;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Item>(
      hint: const Text('Select an item'),
      value: selectedItem ?? widget.list.first,
      onChanged: (Item? newValue) {
        setState(() {
          selectedItem = newValue;
        });
      },
      items: widget.list.map((Item item) {
        return DropdownMenuItem<Item>(
          value: item,
          child: SizedBox(
            width: 200,
            height: 200,
            child: ListTile(
              leading: Icon(item.icon),
              title: Text(item.name),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class Item {
  final String name;
  final IconData icon;

  Item({required this.name, required this.icon});
}
