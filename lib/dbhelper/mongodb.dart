import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../models/userModels.dart';
import 'constant.dart';

class MongoDB {
  static var db, usercollection;

  // Connect to the MongoDB database
  static Future<void> connect() async {
    try {
      db = await Db.create(MONGO_CONN_URL);
      await db!.open();
      usercollection = db!.collection(USER_COLLECTION);
      print("Connected to MongoDB");
    } catch (e) {
      print("Error connecting to MongoDB: $e");
    }
  }

  // Hash the password using SHA-256
  static String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Insert a new user into the database
  // static Future<String> insert(MongoDbModel data) async {
  //   try {
  //     // Hash the password before inserting
  //     print("inside adding data");
  //     MongoDB.connect();
  //     data.password = hashPassword(data.password);
  //
  //     var result = await usercollection.insertOne(data.toJson());
  //
  //     if (result.ok == 1) {
  //       // Check for success using result.ok
  //       return "success";
  //     } else {
  //       return "Failed to insert";
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     return "Error: ${e.toString()}";
  //   }
  // }

  static Future<String> insert(MongoDbModel data) async {
    try {
      print("inside adding data");

      // Ensure the connection is established properly
      await MongoDB.connect();

      // Hash the password before inserting
      data.password = hashPassword(data.password);

      // Insert the document into the collection
      var result = await MongoDB.usercollection.insert(data.toJson());

      return "success";
    } catch (e) {
      print(e.toString());
      return "Error: ${e.toString()}";
    }
  }

  // Update an existing user in the database

  static Future<String> update(data) async {
    await MongoDB.connect();

    // Assuming data is a Map<String, dynamic>
    var existingUser = await usercollection
        .findOne({'_id': data.id}); // Use '_id' instead of 'id'

    if (existingUser == null) {
      return "User not found";
    }

    try {
      final updateOperations = modify
          .set("name", data.name)
          .set("email", data.cid)
          .set("phoneNo", data.phoneNo)
          .set("emergency", data.emergency)
          .set("password", data.password)
          .set("photo", data.photo);

      var result = await usercollection.updateMany(
        where.eq("_id", data.id), // Corrected query
        updateOperations,
      );

      return "success";
    } catch (e) {
      print('Error updating documents: $e');
      throw e;
    }
  }

  // Get data from the database
  static Future<List<Map<String, dynamic>>> getData() async {
    await MongoDB.connect();
    final arrData = await usercollection.find();
    return arrData.toList();
  }

  static Future<Map<String, dynamic>> findOne(id) async {
    var result = await usercollection.findOne({'_id': id});
    return result; // Return a single document (a map)
  }

  static Future<Map<String, dynamic>> findCid(cid) async {
    print("inside finding cid");
    await MongoDB.connect();

    var result = await usercollection.findOne({'cid': cid});
    return result; // Return a single document (a map)
  }
}
