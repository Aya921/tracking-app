// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:injectable/injectable.dart';
// import 'package:tracking_app/core/constants/constants.dart';
// @lazySingleton
// class UserLocalStorageImpl {
//   final FlutterSecureStorage storage;
//
//   UserLocalStorageImpl({FlutterSecureStorage? storage})
//       : storage = storage ?? const FlutterSecureStorage();
//
//   Future<void> saveToken(String token) async {
//     try {
//       await storage.write(key: Constants.token, value: token);
//     } catch (e) {
//       throw Exception('${Constants.failedToSaveToken}: $e');
//     }
//   }
//   Future<String?> getToken() async {
//     try {
//       return await storage.read(key: Constants.token);
//     } catch (e) {
//       throw Exception('${Constants.failedToGetToken}: $e');
//     }
//   }
//
//   Future<void> deleteToken() async {
//     try {
//       await storage.delete(key: Constants.token);
//     } catch (e) {
//       throw Exception('${Constants.failedToDeleteToken}: $e');
//     }
//   }
//
//   Future<bool> isLoggedIn() async {
//     try {
//       return await storage.containsKey(key: Constants.token);
//     } catch (e) {
//       throw Exception('${Constants.failedToCheckLoginStatus}: $e');
//     }
//   }
// }
