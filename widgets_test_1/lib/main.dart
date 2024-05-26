import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgets_test_1/custom_theme.dart';
import 'package:widgets_test_1/drawer_item_builder.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      home: const MyHomePage(title: "Widget Test"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //* for the drawer
  final DrawerItemBuilder _drawerItemProvider = DrawerItemBuilder();
  int _selectedDrawerIndex = 0;
  String appBarText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarText),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            for (var index = 0; index < _drawerItemProvider.getDrawerItems.length; index++)
              ListTile(
                leading: Icon(_drawerItemProvider.getDrawerItems[index].icon),
                title: Text(
                  _drawerItemProvider.getDrawerItems[index].title,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
                ),
                selected: index == _selectedDrawerIndex,
                onTap: () {
                  setState(() {
                    _selectedDrawerIndex = index;
                    appBarText = _drawerItemProvider.getDrawerItems[index].title;
                  });
                  Navigator.pop(context); // close drawer
                },
              ),
          ],
        ),
      ),
      body: _drawerItemProvider.getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}
