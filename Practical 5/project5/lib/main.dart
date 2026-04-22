import 'package:flutter/material.dart';

class _SelectionButtonState extends State<SelectionButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      spacing: 20,
      children: [
        ElevatedButton(
          onPressed: (){
            _navigateAndDisplaySelection(context);
          },
          child: Text('Pick an option'),
        ),
        Text(_selectedOption ?? 'Nothing Picked'),
      ],
    );
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectionScreen()),
    );
    print(result)
      onPressed: () {
        Navigator.pop(context, widget
      },
      child: Text(widget.selection),
    );
  }
}