import 'package:flutter/material.dart';

class EditTaskDialog extends StatefulWidget {
  final String title;
  final String description;
  final int isCompleted; // Keep this as int
  final Function(String, String, int) onEditTask;

  EditTaskDialog({
    required this.title,
    required this.description,
    required this.isCompleted, // Expect an int (0 or 1)
    required this.onEditTask,
  });

  @override
  _EditTaskDialogState createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late bool _isCompletedBool; // Use a bool to manage checkbox state internally

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
    _isCompletedBool = widget.isCompleted == 1; // Convert int to bool
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          Row(
            children: [
              Text('Completed'),
              Checkbox(
                value: _isCompletedBool,
                onChanged: (bool? value) {
                  setState(() {
                    _isCompletedBool = value ?? false;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onEditTask(
              _titleController.text,
              _descriptionController.text,
              _isCompletedBool ? 1 : 0, // Convert bool back to int
            );
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
