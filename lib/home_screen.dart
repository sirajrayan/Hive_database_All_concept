import 'dart:io';

import 'package:example_hive_database/contactListScreen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'model.dart';

class HomeScreen extends StatefulWidget {
   HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final descriptionController = TextEditingController();

  File? image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = basename(pickedFile.path);
      final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');
      setState(() => image = savedImage);
    }
  }

  Future<void> _saveContact() async {
    if (_formKey.currentState!.validate() && image != null) {
      final newContact = Contact(
        name: nameController.text,
        email: emailController.text,
        description: descriptionController.text,
        imagePath: image!.path,
      );
      final box = Hive.box<Contact>('contacts');
      await box.add(newContact);


      nameController.clear();
      emailController.clear();
      descriptionController.clear();
      setState(() => image = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Contact')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: image != null ? FileImage(image!) : null,
                    child: image == null ? const Icon(Icons.add_a_photo) : null,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  validator: (value) => value == null || value.isEmpty ? 'Enter name' : null,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: emailController,
                  validator: (value) => value == null || value.isEmpty ? 'Enter email' : null,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: descriptionController,
                  validator: (value) => value == null || value.isEmpty ? 'Enter description' : null,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: _saveContact, child: const Text('Save Contact')),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  ViewContactsScreen())),
                  child: const Text('View Contacts'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
