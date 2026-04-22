class Dog {
  final int? id;
  final String name;
  final String breed;
  final int age;

  Dog({
    this.id,
    required this.name,
    required this.breed,
    required this.age,
  });

  factory Dog.fromMap(Map<String, dynamic> json) => Dog(
        id: json['id'],
        name: json['name'],
        breed: json['breed'],
        age: json['age'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'age': age,
    };
  }
}
