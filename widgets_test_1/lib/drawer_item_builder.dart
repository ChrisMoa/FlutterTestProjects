import 'package:flutter/material.dart';
import 'package:widgets_test_1/custom_widgets/custom_column_widget_template.dart';
import 'package:widgets_test_1/custom_widgets/custom_row_widget_template.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class DrawerItemBuilder {
  // Liste der Drawer-Einträge
  final List<DrawerItem> _drawerItems = [
    DrawerItem("CustomColumnWidgetTemplate", Icons.home),
    DrawerItem("CustomRowWidgetTemplate", Icons.settings),
    // DrawerItem("Calendar", Icons.calendar_month),
    // DrawerItem("Wizard", Icons.add_to_photos_rounded),
    // DrawerItem("Notes Overview", Icons.account_balance_wallet_sharp),
    // DrawerItem("Datasynchronization", Icons.cloud_upload),
    // DrawerItem("About", Icons.info_outline),
  ];
  List<DrawerItem> get getDrawerItems => _drawerItems;

  // Funktion, um die Haupt-Inhaltsseite basierend auf dem ausgewählten Eintrag anzuzeigen
  getDrawerItemWidget(int index) {
    switch (index) {
      case 0:
        return const CustomColumnWidgetTemplate();
      case 1:
        return const CustomRowWidgetTemplate();
      // case 1:
      //   return const SettingsPage();
      // case 2:
      //   return const CalendarPage();
      // case 3:
      //   return const NoteWizardPage();
      // case 4:
      //   return const NotesOverViewPage();
      // case 5:
      //   return const SynchronizePage();
      // case 6:
      //   return const AboutPage();

      default:
        return const Text("Fehler: Ungültiger Eintrag");
    }
  }
}
