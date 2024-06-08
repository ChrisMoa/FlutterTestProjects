import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:widgets_test_1/custom_extensions.dart';

class TestUser {
  String id;
  bool isUser;
  int age;
  double days;
  String name;

  TestUser({String? id, bool? isUser, int? age, double? days, String? name})
      : isUser = isUser ?? false,
        age = age ?? 0,
        days = days ?? 0.0,
        name = name ?? '',
        id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'isUser': isUser,
      'age': age,
      'days': days,
      'name': name,
    };
  }

  factory TestUser.fromMap(Map<String, dynamic> map) {
    return TestUser(
      id: map['id'] as String,
      isUser: map['isUser'] as bool,
      age: map['age'] as int,
      days: map['days'] as double,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TestUser.fromJson(String source) => TestUser.fromMap(json.decode(source) as Map<String, dynamic>);

  String getPrimaryKey() => id;
}

// ----------------------------------------------------------------------------------------------------------------------------------------------------
final kDummyTestUsers = [
  // generates some samplesList<TestUser> dummyTestUsers = [
  TestUser(
    id: '1',
    name: 'John Doe',
    days: 365.0,
    isUser: false,
    age: 25,
  ),
  TestUser(
    id: '2',
    name: 'Jane Smith',
    days: 305.0,
    isUser: false,
    age: 30,
  ),
  TestUser(
    id: '3',
    name: 'Bob Johnson',
    days: 355.0,
    isUser: false,
    age: 35,
  ),
  TestUser(
    id: '4',
    name: 'Alice Williams',
    days: 315.0,
    isUser: false,
    age: 40,
  ),
  TestUser(
    id: '5',
    name: 'Tom Brown',
    days: 335.0,
    isUser: false,
    age: 45,
  ),
];

class TestUserProviderState extends StateNotifier<List<TestUser>> {
  TestUserProviderState() : super(kDummyTestUsers);

  Future<void> addElement(TestUser element) async {
    state = [...state, element];
  }

  Future<void> deleteElement(TestUser element) async {
    state = state.where((curElement) => curElement.getPrimaryKey() != element.getPrimaryKey()).toList();
  }

  Future<void> editElement(TestUser newElement, [TestUser? oldElement]) async {
    final idElement = oldElement ?? newElement;
    state = state.map((curElement) => curElement.getPrimaryKey() == idElement.getPrimaryKey() ? newElement : curElement).toList();
  }

  Future<void> clearProvider() async {
    state = [];
  }
}

final testuserListProvider = StateNotifierProvider<TestUserProviderState, List<TestUser>>((ref) {
  return TestUserProviderState();
});

class FunctionNotifier extends ChangeNotifier {
  void triggerSaveList() {
    notifyListeners();
  }
}

final functionProvider = ChangeNotifierProvider((_) => FunctionNotifier());

class OverviewList extends ConsumerStatefulWidget {
  const OverviewList({super.key});

  @override
  ConsumerState<OverviewList> createState() => _OverviewListState();
}

class _OverviewListState extends ConsumerState<OverviewList> {
  @override
  Widget build(BuildContext context) {
    final list = ref.watch(testuserListProvider);
    if (list.isEmpty) {
      return Text(
        "UUh, nothing here",
        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
      );
    } else {
      return ListView.builder(
        itemBuilder: (ctx, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Dismissible(
            key: ValueKey(list[index]),
            onDismissed: (direction) {
              _onRemoveListItem(list[index]);
            },
            child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                child: OverviewListItem(id: list[index].getPrimaryKey())),
          ),
        ),
        itemCount: list.length,
      );
    }
  }

  void _onRemoveListItem(TestUser testuser) {
    ref.read(testuserListProvider.notifier).deleteElement(testuser);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text('${testuser.getPrimaryKey()} deleted!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            ref.read(testuserListProvider.notifier).addElement(testuser);
          },
        ),
      ),
    );
  }
}

class OverviewListItem extends ConsumerStatefulWidget {
  const OverviewListItem({super.key, required this.id});
  final String id;

  @override
  ConsumerState<OverviewListItem> createState() => _OverviewListItemState();
}

class _OverviewListItemState extends ConsumerState<OverviewListItem> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _isUserController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _checkBoxState = false;

  @override
  void dispose() {
    _isUserController.dispose();
    _ageController.dispose();
    _daysController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var item = ref.read(testuserListProvider).firstWhere((element) => element.getPrimaryKey() == widget.id);
    _isUserController.text = item.isUser.toString();
    _ageController.text = item.age.toString();
    _daysController.text = item.days.toString();
    _nameController.text = item.name;

    final notifier = ref.watch(functionProvider);
    ref.listen(functionProvider, (previous, next) {
      _onSave();
    });

    return ConstrainedBox(
      constraints: const BoxConstraints.expand(height: 400),
      child: Container(
        // decoration: BoxDecoration(
        //   color: Theme.of(context).colorScheme.onSecondary,
        //   border: Border.all(
        //     color: Theme.of(context).colorScheme.inversePrimary,
        //     width: 1.0,
        //     style: BorderStyle.solid,
        //   ),
        //   borderRadius: BorderRadius.circular(10),
        // ),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 75,
              width: double.infinity,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Text(
                  item.getPrimaryKey(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
                ),
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints.expand(height: 300),
              child: Form(
                key: _formKey,
                child: GridView(
                  // physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    mainAxisExtent: 75,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 10,
                  ),
                  children: [
                    TextFormField(
                      controller: _isUserController,
                      decoration: const InputDecoration(labelText: 'IsUser'),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a isUser';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(labelText: 'Age'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a age';
                        }
                        if (num.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _daysController,
                      decoration: const InputDecoration(labelText: 'Days'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a days';
                        }
                        if (num.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }

                        return null;
                      },
                    ),
                    CheckboxListTile(
                      title: Text(
                        "Check! Mate?",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
                      ),
                      secondary: Icon(
                        Icons.ac_unit,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      value: _checkBoxState,
                      onChanged: (value) {
                        setState(() {
                          _checkBoxState = !_checkBoxState;
                        });
                      },
                    ),
                    ButtonBar(
                      buttonPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            notifier.triggerSaveList();
                          },
                          child: Text(
                            "Hit me",
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            notifier.triggerSaveList();
                          },
                          child: Text(
                            "Hit me",
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSave() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      TestUser testUser = TestUser(age: _ageController.text.toInt(), isUser: _isUserController.text.toBool(), days: _daysController.text.toDouble(), name: _nameController.text);
      ref.read(testuserListProvider.notifier).editElement(testUser);
    }
  }
}
