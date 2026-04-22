class Dog {
  final int? id;
  final String name;
  final int age;

  Dog({this.id, required this.name, required this.age});

  factory Dog.fromMap(Map<String, dynamic> map) {
    return Dog(
      id: map['id'] as int?,
      name: map['name'] as String,
      age: map['age'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {'name': name, 'age': age};
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
