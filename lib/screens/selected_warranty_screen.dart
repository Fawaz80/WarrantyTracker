import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:warranty_tracker_project/models/item.dart';

class SelectedWarrantyScreen extends StatefulWidget {
  const SelectedWarrantyScreen({super.key, required this.item});
  final Item item;
  @override
  State<SelectedWarrantyScreen> createState() => _SelectedWarrantyScreenState();
}

class _SelectedWarrantyScreenState extends State<SelectedWarrantyScreen> {
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController warrantyName = TextEditingController();
  final TextEditingController receiptName = TextEditingController();
  final TextEditingController notes = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selected Warranty'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              buildTextField(widget.item.getName, warrantyName),
              const SizedBox(height: 20),
              buildTextField(widget.item.getReceipt, receiptName),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildSelectDateButton(
                      widget.item.getStartDate, startDateController),
                  buildSelectDateButton(
                      widget.item.getEndDate, endDateController),
                ],
              ),
              const SizedBox(height: 20),
              buildTextField(widget.item.getNotes, notes),
              const SizedBox(height: 20),
              if (widget.item.getImage != null)
                Image.file(
                  widget.item.getImage! as File,
                  width: 100,
                  height: 100,
                )
              else
                const Text('No image uploaded'),
              const SizedBox(height: 20),
              Text('Update barcode/QR code'),
              const SizedBox(height: 20),
              // Button to allow user to select image or take a picture
              ElevatedButton(
                onPressed: () async {
                  final ImageSource? source = await showDialog<ImageSource>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Select Image Source'),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, ImageSource.camera),
                            child: const Text('Camera'),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, ImageSource.gallery),
                            child: const Text('Gallery'),
                          ),
                        ],
                      );
                    },
                  );

                  if (source != null) {
                    // TODO: Use image_picker package save the image
                  }
                },
                child: const Text('Select Image'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Handle save action
                    },
                    child: const Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Handle cancel action
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String? label, TextEditingController controller) {
    return TextField(
      maxLines: 1,
      controller: controller,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        hintText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    );
  }

  Widget buildSelectDateButton(String label, TextEditingController controller) {
    return SizedBox(
      width: 150,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: const Icon(Icons.calendar_today),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime(2100),
          );

          if (pickedDate != null) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            setState(() {
              controller.text = formattedDate;
            });
          }
        },
      ),
    );
  }
}
