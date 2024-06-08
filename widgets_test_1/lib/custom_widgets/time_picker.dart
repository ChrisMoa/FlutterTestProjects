import 'package:flutter/material.dart';

class TimePicker extends StatefulWidget {
  final int initialHour;
  final int initialMinute;
  final int startHour;
  final int endHour;
  final int minuteStep;

  const TimePicker({
    super.key,
    this.initialHour = 0,
    this.initialMinute = 0,
    this.startHour = 0,
    this.endHour = 23,
    this.minuteStep = 15,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  late FixedExtentScrollController _hoursController;
  late FixedExtentScrollController _minutesController;

  int selectedHour = 0;
  int selectedMinute = 0;

  List<int> minuteList = [];

  @override
  void initState() {
    super.initState();

    selectedHour = widget.initialHour;
    selectedMinute = widget.initialMinute;

    // Generate minute list based on the provided minute step, only within the startHour and endHour range
    minuteList = List.generate(
      ((widget.endHour + 1) * 60 - widget.startHour * 60) ~/ widget.minuteStep,
      (index) => widget.startHour * 60 + index * widget.minuteStep,
    ).where((minute) => (minute ~/ 60) <= widget.endHour).toList();

    _hoursController = FixedExtentScrollController(initialItem: selectedHour - widget.startHour);
    _minutesController = FixedExtentScrollController(initialItem: minuteList.indexOf(widget.initialHour * 60 + selectedMinute));
  }

  List<String> _generateMinutes() {
    return minuteList.map((minute) {
      int hour = minute ~/ 60;
      int min = minute % 60;
      return '$hour:${min.toString().padLeft(2, '0')}';
    }).toList();
  }

  List<String> _generateHours() {
    return List.generate((widget.endHour - widget.startHour + 1), (index) => (widget.startHour + index).toString().padLeft(2, '0'));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildScrollWheel(
          controller: _hoursController,
          items: _generateHours(),
          onSelectedItemChanged: (index) {
            setState(() {
              selectedHour = widget.startHour + index;
            });
          },
        ),
        Text(
          ":",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
        ),
        _buildScrollWheel(
          controller: _minutesController,
          items: _generateMinutes().map((minute) => minute.split(":")[1]).toList(),
          onSelectedItemChanged: (index) {
            int minute = minuteList[index];
            setState(() {
              selectedMinute = minute % 60;
              selectedHour = minute ~/ 60;
              _hoursController.jumpToItem(selectedHour - widget.startHour);
            });
          },
        ),
      ],
    );
  }

  Widget _buildScrollWheel({
    required FixedExtentScrollController controller,
    required List<String> items,
    required ValueChanged<int> onSelectedItemChanged,
  }) {
    const double itemHeight = 30;
    return SizedBox(
      height: 3 * itemHeight, // You can adjust this height as needed
      width: 50,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        physics: const FixedExtentScrollPhysics(),
        itemExtent: itemHeight, // Adjust this value to change the height space between items
        onSelectedItemChanged: onSelectedItemChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: items.length,
          builder: (context, index) {
            final selectedItemIndex = controller.selectedItem;
            final isSelectedItem = index == selectedItemIndex;

            final textStyle = isSelectedItem
                ? Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer)
                : Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer);

            return Center(
              child: Text(
                items[index],
                style: textStyle,
              ),
            );
          },
        ),
      ),
    );
  }
}
