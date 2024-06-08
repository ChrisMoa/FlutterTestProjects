// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgets_test_1/custom_widgets/dynamic_dropdown_menu.dart';

class DynamicDropdownMenuTemplate<T> {
  final itemListProvider = StateNotifierProvider<ListNotifier<T>, List<T>>((ref) => ListNotifier());
  final selectedItemProvider = StateProvider<T?>((ref) => null);
  Widget dropdownMenuItemChild = const Text('overwrite me');
  late DropdownMenuExample dropdownMenuExample;

  DynamicDropdownMenuTemplate() {
    dropdownMenuExample = DropdownMenuExample(
      itemListProvider: itemListProvider,
      selectedItemProvider: selectedItemProvider,
      dropdownMenuItemChild: dropdownMenuItemChild,
    );
  }
}

class DynamicDropdownItem {
  String name;
  Icon icon;

  DynamicDropdownItem({
    required this.name,
    required this.icon,
  });
}

class FirstDynamicDropdownMenu extends DynamicDropdownMenuTemplate<DynamicDropdownItem> {
  FirstDynamicDropdownMenu() : super();

  @override
  // ignore: overridden_fields
  final Widget dropdownMenuItemChild = const ListTile(
    leading: Icon(Icons.add),
    title: Text('Add'),
  );
}
