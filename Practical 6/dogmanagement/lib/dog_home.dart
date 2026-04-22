import 'package:flutter/material.dart';

import 'dog.dart';
import 'dog_db.dart';

class DogHome extends StatefulWidget {
  const DogHome({super.key});

  @override
  State<DogHome> createState() => _DogHomeState();
}

class _DogHomeState extends State<DogHome> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<Dog> _dogs = [];
  Dog? _editingDog;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadDogs();
  }

  Future<void> _loadDogs() async {
    final dogs = await DogDatabase.instance.readAllDogs();
    if (!mounted) return;
    setState(() {
      _dogs = dogs;
    });
  }

  Future<void> _saveDog() async {
    if (!_formKey.currentState!.validate()) return;

    final dog = Dog(
      id: _editingDog?.id,
      name: _nameController.text.trim(),
      age: int.parse(_ageController.text.trim()),
    );

    setState(() {
      _isSaving = true;
    });

    try {
      if (_editingDog == null) {
        await DogDatabase.instance.createDog(dog);
        _showMessage('Dog added successfully');
      } else {
        await DogDatabase.instance.updateDog(dog);
        _showMessage('Dog updated successfully');
      }

      _clearForm();
      await _loadDogs();
    } catch (_) {
      _showMessage('Failed to save dog', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _deleteDog(Dog dog) async {
    if (dog.id == null) return;

    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('Delete Dog'),
                ],
              ),
              content: Text('Delete ${dog.name}?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                FilledButton.icon(
                  onPressed: () => Navigator.pop(context, true),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!confirmed) return;

    try {
      await DogDatabase.instance.deleteDog(dog.id!);
      _showMessage('Dog deleted');
      await _loadDogs();
    } catch (_) {
      _showMessage('Failed to delete dog', isError: true);
    }
  }

  void _startEdit(Dog dog) {
    setState(() {
      _editingDog = dog;
      _nameController.text = dog.name;
      _ageController.text = dog.age.toString();
    });
  }

  void _clearForm() {
    _nameController.clear();
    _ageController.clear();
    setState(() {
      _editingDog = null;
    });
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.teal,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.pets),
            SizedBox(width: 8),
            Text('Dog Management'),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _editingDog == null
                                  ? Icons.add_circle_outline
                                  : Icons.edit_note,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _editingDog == null ? 'Add New Dog' : 'Edit Dog',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            hintText: 'e.g. Bruno',
                            prefixIcon: Icon(Icons.badge_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a dog name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Age',
                            hintText: 'e.g. 3',
                            prefixIcon: Icon(Icons.cake_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter age';
                            }
                            final age = int.tryParse(value.trim());
                            if (age == null || age < 0) {
                              return 'Enter a valid age';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _isSaving ? null : _saveDog,
                                icon: Icon(
                                  _editingDog == null
                                      ? Icons.add
                                      : Icons.save_outlined,
                                ),
                                label: Text(
                                  _editingDog == null ? 'Add Dog' : 'Update Dog',
                                ),
                              ),
                            ),
                            if (_editingDog != null) ...[
                              const SizedBox(width: 8),
                              OutlinedButton.icon(
                                onPressed: _isSaving ? null : _clearForm,
                                icon: const Icon(Icons.close),
                                label: const Text('Cancel'),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _dogs.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.pets_outlined, size: 48),
                            SizedBox(height: 8),
                            Text('No dogs saved yet'),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: _dogs.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final dog = _dogs[index];
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  dog.name.isEmpty
                                      ? '?'
                                      : dog.name[0].toUpperCase(),
                                ),
                              ),
                              title: Text(dog.name),
                              subtitle: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.cake_outlined, size: 16),
                                  const SizedBox(width: 4),
                                  Text('${dog.age} years old'),
                                ],
                              ),
                              trailing: Wrap(
                                spacing: 2,
                                children: [
                                  IconButton(
                                    tooltip: 'Edit',
                                    onPressed: () => _startEdit(dog),
                                    icon: const Icon(Icons.edit_outlined),
                                  ),
                                  IconButton(
                                    tooltip: 'Delete',
                                    onPressed: () => _deleteDog(dog),
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}