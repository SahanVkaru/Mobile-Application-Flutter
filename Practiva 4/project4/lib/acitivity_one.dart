import 'package:flutter/material.dart';

class AcitivityOne extends StatefulWidget {
  const AcitivityOne({super.key});

  @override
  State<AcitivityOne> createState() => _AcitivityOneState();
}

class _AcitivityOneState extends State<AcitivityOne> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity One')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your name',
                ),
                controller: _controller,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                controller: _controller2,
              ), // TextformFiled
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print("Text from TextField 1: ${_controller.text}");
                    print("Text from TextField 2: ${_controller2.text}");
                  }
                },
                child: const Text('Submit'),
              ), // ElevatedButton
            ],
          ),
        ),
      ),
    );
  }
}
