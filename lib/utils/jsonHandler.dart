import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';


class JsonHandler {
  // The path to the JSON file
  final String filePath;

  JsonHandler(this.filePath);

  // Read text from the JSON file
  Future<Map<String, dynamic>?> readText() async {
    try {
      String jsonString = await rootBundle.loadString('assets/json/$filePath');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      return jsonMap;
    } catch (e) {
      print("Error reading JSON file: $e");
      return null;
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    final directory = Directory('$path/json/');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return File('$path/json/$filePath');
  }
  Future<void> writeToFile(String data) async {
    final file = await _localFile;
    await file.writeAsString(data);
  }
  // Future<String> readFile() async {
  //   final file = await _localFile;
  //   String fileContent = await file.readAsStringSync();
  //   return fileContent;
  // }
  Future<Map<String, dynamic>?> readFile() async {
    try {
      // Read the file content as a String
      File fileContent = await _localFile;// ... your file reading logic here ...

      // Parse the String as JSON
      Map<String, dynamic> jsonData = json.decode(fileContent.readAsStringSync());

      return jsonData;
    } catch (e) {
      print('Error reading file: $e');
      return null; // or throw an exception based on your error handling strategy
    }
  }
  Future<bool> checkFileExist() async {
    try {
      File fileContent = await _localFile; // Replace with your file reading logic

      // Use the exists() method directly
      bool exists = await fileContent.exists();

      return exists;
    } catch (e) {
      // Handle exceptions if any
      print('Error checking file existence: $e');
      return false;
    }
  }
}
