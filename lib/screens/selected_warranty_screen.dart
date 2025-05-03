import 'package:flutter/material.dart';
import '../models/item.dart';
import '../models/user.dart';
import '../services/firebase_service.dart';
import 'package:intl/intl.dart';

class SelectedWarrantyScreen extends StatefulWidget {
  final User user;
  final Item item;
  final String userId;
  final String itemId;

  const SelectedWarrantyScreen({
    super.key,
    required this.user,
    required this.item,
    required this.userId,
    required this.itemId,
  });

  @override
  State<SelectedWarrantyScreen> createState() => _SelectedWarrantyScreenState();
}

class _SelectedWarrantyScreenState extends State<SelectedWarrantyScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _receiptController;
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;
  late final TextEditingController _notesController;
  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _receiptController = TextEditingController(text: widget.item.receipt);
    _startDateController = TextEditingController(text: widget.item.startDate);
    _endDateController = TextEditingController(text: widget.item.endDate);
    _notesController = TextEditingController(text: widget.item.notes);
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateFormat('yyyy-MM-dd').parse(controller.text),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(date);
    }
  }

  Future<void> _updateItem() async {
    setState(() => _isLoading = true);

    try {
      final updatedData = {
        'name': _nameController.text,
        'receipt': _receiptController.text,
        'startDate': _startDateController.text,
        'endDate': _endDateController.text,
        'notes': _notesController.text,
      };

      await _firebaseService.updateItem(
        widget.userId, 
        widget.itemId, 
        updatedData,
      );

      // Update local item
      final index = widget.user.items.indexWhere((i) => i.id == widget.itemId);
      if (index != -1) {
        widget.user.items[index] = Item.fromJson(updatedData)..id = widget.itemId;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Warranty updated successfully')),
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
      appBar: AppBar(title: const Text('Edit Warranty')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
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
              ),
              TextFormField(
                controller: _endDateController,
                decoration: const InputDecoration(labelText: 'End Date'),
                readOnly: true,
                onTap: () => _selectDate(_endDateController),
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _updateItem,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}