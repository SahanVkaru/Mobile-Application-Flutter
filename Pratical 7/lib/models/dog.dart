class Dog {
  final int? id;
  final String name;
  final int age;
  final String breed;

  Dog({
    this.id,
    required this.name,
    required this.age,
    required this.breed,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'breed': breed,
    };
  }

  // Convert a Map into a Dog.
  factory Dog.fromMap(Map<String, dynamic> map) {
    return Dog(
      id: map['id'] as int?,
      name: map['name'] as String,
      age: map['age'] as int,
      breed: map['breed'] as String,
    );
  }

  // Implement toString to make it easier to see information about each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age, breed: $breed}';
  }
}
