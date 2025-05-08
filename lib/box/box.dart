
import 'package:hive/hive.dart';

import '../model.dart';

class Boxes {
  static Box<Contact> getData(){
    return Hive.box<Contact>('Contacts');
  }
}