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
  late DrawerItemBuilder _drawerItemProvider;
  int _selectedDrawerIndex = 0;
  String appBarText = "";
  void _onDrawerItemTapped(ChildItem childItem) {
    setState(() {
      _selectedDrawerIndex = childItem.index;
      appBarText = childItem.title;
    });
    Navigator.pop(context); // close drawer
  }

  //* build methods

  @override
  void initState() {
    _drawerItemProvider = DrawerItemBuilder(onItemTapped: _onDrawerItemTapped);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarText),
      ),
      drawer: Drawer(
        child: _drawerItemProvider.generateList(),
      ),
      body: _drawerItemProvider.getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}
