import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/item.dart';
import '../services/firebase_service.dart';

class NewWarrantyScreen extends StatefulWidget {
  final String userId;
  final Function(Item) onItemAdded;

  const NewWarrantyScreen({
    super.key,
    required this.userId,
    required this.onItemAdded,
  });

  @override
  State<NewWarrantyScreen> createState() => _NewWarrantyScreenState();
}

class _NewWarrantyScreenState extends State<NewWarrantyScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _receiptController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = false;

  Future<void> _selectDate(TextEditingController controller) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(date);
    }
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final newItem = {
        'name': _nameController.text,
        'receipt': _receiptController.text,
        'startDate': _startDateController.text,
        'endDate': _endDateController.text,
        'notes': _notesController.text,
      };

      final itemId = await _firebaseService.addItem(widget.userId, newItem);
      
      final item = Item.fromJson(newItem)..id = itemId;
      widget.onItemAdded(item);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Warranty added successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Warranty')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
                validator: (value) => 
                    value?.isEmpty ?? true ? 'Required field' : null,
              ),
              TextFormField(
                controller: _receiptController,
                decoration: const InputDecoration(labelText: 'Receipt Number'),
              ),
              TextFormField(
                controller: _startDateController,
                decoration: const InputDecoration(labelText: 'Start Date'),
                readOnly: true,
                onTap: () => _selectDate(_startDateController),
                validator: (value) => 
                    value?.isEmpty ?? true ? 'Required field' : null,
              ),
              TextFormField(
                controller: _endDateController,
                decoration: const InputDecoration(labelText: 'End Date'),
                readOnly: true,
                onTap: () => _selectDate(_endDateController),
                validator: (value) => 
                    value?.isEmpty ?? true ? 'Required field' : null,
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveItem,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Save Warranty'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}