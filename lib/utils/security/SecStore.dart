import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecStore {
  //Create storage
  FlutterSecureStorage storage = new FlutterSecureStorage();

  //Write value
  _write(FlutterSecureStorage storage, String key, String value) async {
    await storage.write(key: key, value: value);
  }

  //Read value
  Future<String?> _read(FlutterSecureStorage storage, String key) async {
    return await storage.read(key: key);

    // return await storage.read(key: key);
  }

  //Delete value
  _delete(FlutterSecureStorage storage, String key) async {
    await storage.delete(key: key);
  }

  //Read all values
  Future<Map<String, String>> _viewAll(FlutterSecureStorage storage) async {
    return await storage.readAll();
  }

  //Delete all
  _deleteAll() async {
    await storage.deleteAll();
  }
}
