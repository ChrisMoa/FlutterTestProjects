import 'package:flutter/material.dart';

class CustomColumnWidgetTemplate extends StatelessWidget {
  const CustomColumnWidgetTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary,
                border: Border.all(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Reihe1",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary,
                border: Border.all(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Reihe1",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
