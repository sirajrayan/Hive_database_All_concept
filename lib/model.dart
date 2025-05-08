import 'dart:io';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Optional but useful if you're using HiveFlutter


///---dependencies needed
//hive: ^2.2.3
//hive_flutter: ^1.1.0
//path_provider: ^2.1.1
//dev------ok
//build_runner: ^2.4.6
//hive_generator: ^2.0.1

//commond to genrat .g.dart file of model
//flutter packages pub run build_runner build

part "model.g.dart";

@HiveType(typeId: 0)
class Contact extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String description;

  @HiveField(3)
  String imagePath;

  Contact({
    required this.name,
    required this.email,
    required this.description,
    required this.imagePath,
  });
}

