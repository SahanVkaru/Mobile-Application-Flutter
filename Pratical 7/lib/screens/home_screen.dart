import 'package:flutter/material.dart';
import '../models/dog.dart';
import '../database/database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Dog> dogs;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshDogs();
  }

  Future refreshDogs() async {
    setState(() => isLoading = true);
    dogs = await DatabaseHelper.instance.readAllDogs();
    setState(() => isLoading = false);
  }

  void _showForm(int? id) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
    final TextEditingController breedController = TextEditingController();

    if (id != null) {
      final existingDog = dogs.firstWhere((element) => element.id == id);
      nameController.text = existingDog.name;
      ageController.text = existingDog.age.toString();
      breedController.text = existingDog.breed;
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Dog Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Age (Years)'),
            ),
             const SizedBox(height: 10),
            TextField(
              controller: breedController,
              decoration: const InputDecoration(labelText: 'Breed'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final String name = nameController.text;
                final int age = int.tryParse(ageController.text) ?? 0;
                final String breed = breedController.text;

                if (name.isEmpty || breed.isEmpty) return;
                
                if (id == null) {
                  // Add new dog
                  await DatabaseHelper.instance.create(Dog(
                    name: name,
                    age: age,
                    breed: breed,
                  ));
                } else {
                  // Update existing dog
                  await DatabaseHelper.instance.update(Dog(
                    id: id,
                    name: name,
                    age: age,
                    breed: breed,
                  ));
                }
                
                nameController.clear();
                ageController.clear();
                breedController.clear();

                if (!mounted) return;
                Navigator.of(context).pop();
                refreshDogs();
              },
              child: Text(id == null ? 'Add Dog' : 'Update Dog'),
            )
          ],
        ),
      ),
    );
  }

  void _deleteDog(int id) async {
    await DatabaseHelper.instance.delete(id);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dog successfully deleted!')),
    );
    refreshDogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🐶 Dog Management System'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : dogs.isEmpty
              ? const Center(child: Text('No dogs found. Add some!'))
              : ListView.builder(
                  itemCount: dogs.length,
                  itemBuilder: (context, index) {
                    final dog = dogs[index];
                    return Card(
                      color: Colors.orange[200],
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.orangeAccent,
                          child: Text(
                            dog.name[0].toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        title: Text(dog.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Age: ${dog.age} | Breed: ${dog.breed}'),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showForm(dog.id),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteDog(dog.id!),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}
