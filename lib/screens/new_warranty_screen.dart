import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user.dart';
import 'package:image_picker/image_picker.dart';

class NewWarrantyScreen extends StatefulWidget {
  final User user;

  const NewWarrantyScreen({super.key, required this.user});

  @override
  State<NewWarrantyScreen> createState() => _NewWarrantyScreenState();
}

class _NewWarrantyScreenState extends State<NewWarrantyScreen> {
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController warrantyName = TextEditingController();
  final TextEditingController receiptName = TextEditingController();
  final TextEditingController notes = TextEditingController();

  @override
  void dispose() {
    startDateController.dispose();
    startDateController.dispose();
    warrantyName.dispose();
    receiptName.dispose();
    notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Warranty'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              buildTextField('Warranty Name', warrantyName),
              const SizedBox(height: 20),
              buildTextField('Receipt Number', receiptName),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildSelectDateButton('Start Date', startDateController),
                  buildSelectDateButton('End Date', endDateController),
                ],
              ),
              const SizedBox(height: 20),
              buildTextField('Notes', notes),
              const SizedBox(height: 20),
              Text('Take picture of barcode/QR code'),
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

  Widget buildTextField(String hintText, TextEditingController controller) {
    return TextField(
      maxLines: 1,
      controller: controller,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        hintText: hintText,
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

          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate!);
          setState(() {
            controller.text = formattedDate;
          });
                },
      ),
    );
  }
}
