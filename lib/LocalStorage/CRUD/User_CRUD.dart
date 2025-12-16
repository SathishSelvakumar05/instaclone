import 'package:alab/Cubits/User_Data_State.dart';
import 'package:sqflite/sqflite.dart';

import '../Models/UserModel.dart';

class User{
  Future<void> insertUser(userModel user,Database db) async {
    try{
      await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }catch(e){}
  }
  Future<void> insertUserData(List<UserData> userData,Database db)async{
      for(var data in userData){
        await db.insert(
          'post',
          data.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
  }
  Future<dynamic> getUser(Database db) async {
    final user = await db.query('users',columns: ['mobileNumber']);
    return user;
  }
  Future<List<UserData>> getItems(Database db) async {
    final res = await db.query("post");
    return res.map((e) => UserData.fromJson(e)).toList();
  }
  Future<void> deleteUser(Database db)async{
    await db.delete('post');
  }
  Future<void> logout(Database db)async{
    await db.delete('users');
    await db.delete('post');
  }
}