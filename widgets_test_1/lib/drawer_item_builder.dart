// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:widgets_test_1/custom_container/custom_column_widget_template.dart';
import 'package:widgets_test_1/custom_container/custom_row_widget_template.dart';
import 'package:widgets_test_1/custom_container/tree_view_screen.dart';
import 'package:widgets_test_1/custom_widgets/basic_card.dart';
import 'package:widgets_test_1/custom_widgets/dropdown_menu_example_1.dart';
import 'package:widgets_test_1/custom_widgets/simple_class_overview_list.dart';
import 'package:widgets_test_1/custom_widgets/time_picker.dart';

/// this class defines the different drawer items
///! add the different drawer items here
class DrawerItemBuilder {
  late List<HeaderItem> items;
  final Function(ChildItem childItem) onItemTapped;

  DrawerItemBuilder({required this.onItemTapped}) {
    items = [
      HeaderItem(
        title: 'Container Tests',
        children: [
          ChildItem(
            title: "CustomColumnWidgetTemplate",
            icon: Icons.home,
            onClickWidget: const CustomColumnWidgetTemplate(),
          ),
          ChildItem(
            title: "CustomRowWidgetTemplate",
            icon: Icons.settings,
            onClickWidget: const CustomRowWidgetTemplate(),
          ),
          ChildItem(
            title: "CustomRowWidgetTemplate",
            icon: Icons.settings,
            onClickWidget: TreeViewScreen(),
          ),
          ChildItem(
            title: "SimpleListTemplate",
            icon: Icons.list_outlined,
            onClickWidget: const OverviewList(),
          ),
        ],
      ),
      HeaderItem(
        title: 'Cards',
        children: [
          ChildItem(
            title: "Card1",
            icon: Icons.settings,
            onClickWidget: const BasicCard(),
          ),
          ChildItem(
            title: "First Dropdown",
            icon: Icons.settings,
            onClickWidget: DropdownMenuExample(list: [
              Item(name: 'Item 1', icon: Icons.star),
              Item(name: 'Item 2', icon: Icons.favorite),
              Item(name: 'Item 3', icon: Icons.thumb_up),
            ]),
          ),
          ChildItem(
            title: "Scrollable time picker",
            icon: Icons.lock_clock,
            onClickWidget: const TimePicker(
              startHour: 12,
              endHour: 22,
              minuteStep: 5,
            ),
          ),
        ],
      ),
      HeaderItem(
        title: 'Test Header',
        children: [
          ChildItem(
            title: "TestItem1",
            icon: Icons.settings,
            onClickWidget: const Text("TestItem"),
          ),
          ChildItem(
            title: "TestItem2",
            icon: Icons.view_list_outlined,
            onClickWidget: const Text("TestItem"),
          ),
        ],
      ),
    ];

    // write the index to every element
    int index = 0;
    for (var header in items) {
      for (var childItem in header.children) {
        childItem.index = index;
        index++;
      }
    }
  }

  // Funktion, um die Haupt-Inhaltsseite basierend auf dem ausgewählten Eintrag anzuzeigen
  getDrawerItemWidget(int index) {
    return items.expand((header) => header.children).firstWhere((childItem) => childItem.index == index).onClickWidget;
  }

  Widget generateList() {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return HeaderWidget(
          header: items[index],
          onItemTapped: onItemTapped,
        );
      },
    );
  }
}

class ChildItem {
  String title;
  IconData icon;
  Widget onClickWidget;
  int index;

  ChildItem({required this.title, required this.icon, required this.onClickWidget, this.index = 0});
}

class HeaderItem {
  String title;
  List<ChildItem> children;

  HeaderItem({required this.title, required this.children});
}

class HeaderWidget extends StatelessWidget {
  final HeaderItem header;
  final Function(ChildItem childItem) onItemTapped;

  const HeaderWidget({
    super.key,
    required this.header,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10.0),
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Text(
            header.title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
          ),
        ),
        ...header.children.map(
          (childItem) {
            return Padding(
              padding: const EdgeInsets.only(left: 32.0, top: 2.0, bottom: 2.0),
              child: ListTile(
                onTap: () {
                  onItemTapped(childItem);
                },
                title: Text(
                  childItem.title,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
                ),
                leading: Icon(childItem.icon),
              ),
            );
          },
        ),
      ],
    );
  }
}
