import 'dart:io';

import 'package:example_hive_database/box/box.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'model.dart';

class ViewContactsScreen extends StatefulWidget {
   ViewContactsScreen({super.key});

  @override
  State<ViewContactsScreen> createState() => _ViewContactsScreenState();
}

class _ViewContactsScreenState extends State<ViewContactsScreen> {
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



  @override
  Widget build(BuildContext context) {
    Future<void> _editContact(Contact contact ,int index,)async{

      nameController.text=contact.name;
      emailController.text=contact.email;
      descriptionController.text=contact.description;
      setState(() {
        image=File(contact.imagePath);
      });
     await showDialog(context: context, builder: (context){

        return StatefulBuilder(
            builder: (context,setstate){
              return AlertDialog(
                title: Text("Edit contact"),
                content: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                  child: SingleChildScrollView(
                      child:Form(child: Column(children: [
                        Column(
                          children: [
                            GestureDetector(
                                onTap: ()async{
                                 await _pickImage();
                                  setstate(() {

                                  });
                                },
                                child:SizedBox(
                                  height: 80,
                                  child: Stack(children: [
                                    CircleAvatar(
                                        radius: 32,
                                        backgroundImage: image!= null ? FileImage(File(image!.path)) : null,
                                        child: image==null ? Icon(Icons.camera_rear_outlined): null
                                    ),
                                    Positioned(bottom: -5,right: 2, child: Icon(Icons.add_a_photo,color: Colors.blueGrey,)),
                                  ],),
                                )),

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
                            ElevatedButton(onPressed: (){
                              final newContact=Contact(name: nameController.text, email: emailController.text, description: descriptionController.text, imagePath: image!.path,);
                              Boxes.getData().putAt( index,newContact);
                              nameController.clear();
                              emailController.clear();
                              descriptionController.clear();
                              setState(() {
                                image=null;
                              });
                              Navigator.pop(context);
                            }, child: const Text('Update Contact')),
                            TextButton(
                              onPressed: () {
                                /// used this tecknique never be confused in deleteing index errror
                                final key = Boxes.getData().keyAt(index); // ✅ get actual key
                                Boxes.getData().delete(key);              // ✅ delete using key

                                Navigator.pop(context);
                              },
                              child: const Text('Delete'),
                            )
                          ],
                        ),
                      ],))
                  ),
                ),
              );
            });
      });
    }

    final box = Hive.box<Contact>('contacts');
    return Scaffold(
      appBar: AppBar(title: const Text('All Contacts')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Contact> contacts, _) {
          if (contacts.isEmpty) {
            return const Center(child: Text('No contacts found'));
          }
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts.getAt(index)!;
              return GestureDetector(
                onLongPress: (){
                  _editContact(contact,index);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: FileImage(File(contact.imagePath)),
                  ),
                  title: Text(contact.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(contact.email),
                      Text(contact.description),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}