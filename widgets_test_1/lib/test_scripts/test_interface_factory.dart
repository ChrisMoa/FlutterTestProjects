// Abstract class with a factory constructor
abstract class Animal {
  // Factory constructor in the abstract class
  factory Animal.fromString({String? sound}) {
    print('called factory constructor of animal');
    throw UnimplementedError('Unknown animal type');
  }

  factory Animal.fromType({int? type, String? classString}) {
    type = type ?? -1;
    switch (type) {
      case 1:
        return Dog.fromString(sound: classString);
      case 2:
        return Cat.fromString(sound: classString);
      default:
        throw UnimplementedError('cant create a new instance of animal');
    }
  }

  String makeSound() {
    throw UnimplementedError('getSound() not implemented');
  }
}

// Concrete subclass Dog
class Dog implements Animal {
  String sound;

  Dog({String? sound}) : sound = sound ?? '' {
    print('called Dog constructor');
  }

  @override
  factory Dog.fromString({String? sound}) {
    return Dog(sound: sound);
  }

  @override
  String makeSound() => sound;
}

// Concrete subclass Cat
class Cat implements Animal {
  String sound;

  Cat({String? sound}) : sound = sound ?? '' {
    print('called Cat constructor');
  }

  @override
  factory Cat.fromString({String? sound}) {
    return Cat(sound: sound);
  }

  @override
  String makeSound() => sound;
}

void main() {
  // Using the factory method to create animals
  try {
    Animal animal = Animal.fromString(sound: 'i dont have this');
    print('${animal.makeSound()}');
  } on UnimplementedError {
    print('caught exception');
  }
  Animal dog = Animal.fromType(type: 1, classString: 'bark');
  Animal cat = Animal.fromType(type: 2, classString: 'meow');

  print(dog.makeSound()); // Outputs: Bark
  print(cat.makeSound()); // Outputs: Meow// Outputs: Persian Meow
}
