import 'package:flutter/material.dart';

class CategoryHeaderItem {
  String title;
  List<ChildItem> children;

  CategoryHeaderItem({required this.title, required this.children});
}

class ChildItem {
  String title;
  IconData icon;
  Widget onClickWidget;

  ChildItem({required this.title, required this.icon, required this.onClickWidget});
}

class HeaderWidget extends StatelessWidget {
  final CategoryHeaderItem header;

  const HeaderWidget({super.key, required this.header});

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
                  // setState(() {
                  //   _selectedDrawerIndex = index;
                  //   appBarText = _drawerItemProvider.getDrawerItems[index].title;
                  // });
                  // Navigator.pop(context); // close drawer
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

class TreeViewScreen extends StatelessWidget {
  final List<CategoryHeaderItem> items = [
    CategoryHeaderItem(
      title: 'Category 1',
      children: [
        ChildItem(title: "CustomColumnWidgetTemplate", icon: Icons.home, onClickWidget: const Text("Item1")),
        ChildItem(title: "CustomRowWidgetTemplate", icon: Icons.settings, onClickWidget: const Text("Item2")),
      ],
    ),
    CategoryHeaderItem(
      title: 'Header 2',
      children: [
        ChildItem(title: "CustomRowWidgetTemplate", icon: Icons.settings, onClickWidget: const Text("Item3")),
        ChildItem(title: "TreeViewScreen", icon: Icons.view_list_outlined, onClickWidget: const Text("Item4")),
      ],
    ),
  ];

  TreeViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return HeaderWidget(header: items[index]);
      },
    );
  }
}
