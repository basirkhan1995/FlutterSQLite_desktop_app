
 import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'json.dart';

class DatabaseHelper{
  final databaseName = "auth.db";

  String users = '''
  CREATE TABLE IF NOT EXISTS users(
  usrId INTEGER PRIMARY KEY AUTOINCREMENT,
  fullName TEXT,
  email TEXT,
  usrName TEXT UNIQUE,
  password TEXT NOT NULL
  )
  ''';

  Future<Database> initDB ()async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);
    return openDatabase(path,version: 1, onCreate: (db, version)async{
      await db.execute(users);
    });  }


   //Authenticate

   Future<bool> authenticate(Users usr)async{
    final Database db = await initDB();
    var res = await db.rawQuery("select * from users where usrName = '${usr.usrName}' AND password = '${usr.password}' ");
    if(res.isNotEmpty){
      return true;
    }else{
      return false;
    }
   }

   //Sign up
   Future<int> createUser(Users usr)async{
    final Database db = await initDB();
    return db.insert("users", usr.toMap());
   }
 }