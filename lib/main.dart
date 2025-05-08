import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'contactListScreen.dart';
import 'home_screen.dart';
import 'model.dart';

void main()async {
  // WidgetsFlutterBinding.ensureInitialized();
  // var directory=await getApplicationDocumentsDirectory() ;
  // //Hive.init(directory.path)  ;
  // await Hive.initFlutter();
  //  Hive.registerAdapter(ContactAdapter());
  //  await Hive.openBox<Contact>('Contacts');
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ContactAdapter());
  await Hive.openBox<Contact>('contacts');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:  HomeScreen(),
    );
  }
}

