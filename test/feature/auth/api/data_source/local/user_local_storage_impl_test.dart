import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/constants/constants.dart';
import 'package:tracking_app/feature/auth/api/data_source/local/user_local_storage_impl.dart';
//import 'user_local_storage_impl_test.mocks.dart';
//
// @GenerateMocks([FlutterSecureStorage])
// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();
//   late MockFlutterSecureStorage mockStorage;
//   late UserLocalStorageImpl userLocalStorage;
//
//   setUp(() {
//     mockStorage = MockFlutterSecureStorage();
//     userLocalStorage = UserLocalStorageImpl(storage: mockStorage);
//   });
//
//   group('UserLocalStorageImpl', () {
//     const testToken = 'test_token';
//
//     group('saveToken', () {
//       test('should save token successfully', () async {
//         when(mockStorage.write(key: Constants.token, value: testToken))
//             .thenAnswer((_) async {});
//
//         await userLocalStorage.saveToken(testToken);
//
//         verify(mockStorage.write(key: Constants.token, value: testToken)).called(1);
//       });
//
//       test('should throw exception when save fails', () async {
//         final exception = Exception('Storage error');
//         when(mockStorage.write(key: Constants.token, value: testToken))
//             .thenThrow(exception);
//
//         expect(
//               () => userLocalStorage.saveToken(testToken),
//           throwsA(isA<Exception>().having(
//                 (e) => e.toString(),
//             'message',
//             'Exception: Failed to save token: $exception',
//           )),
//         );
//       });
//     });
//
//     group('getToken', () {
//       test('should return token when it exists', () async {
//
//         when(mockStorage.read(key: Constants.token))
//             .thenAnswer((_) async => testToken);
//
//
//         final result = await userLocalStorage.getToken();
//
//
//         expect(result, testToken);
//         verify(mockStorage.read(key: Constants.token)).called(1);
//       });
//
//       test('should return null when token does not exist', () async {
//
//         when(mockStorage.read(key: Constants.token)).thenAnswer((_) async => null);
//
//
//         final result = await userLocalStorage.getToken();
//
//
//         expect(result, isNull);
//         verify(mockStorage.read(key: Constants.token)).called(1);
//       });
//
//       test('should throw exception when read fails', () async {
//         // Arrange
//         final exception = Exception('Read error');
//         when(mockStorage.read(key: Constants.token)).thenThrow(exception);
//
//         // Act & Assert
//         expect(
//               () => userLocalStorage.getToken(),
//           throwsA(isA<Exception>().having(
//                 (e) => e.toString(),
//             'message',
//             'Exception: Failed to get token: $exception',
//           )),
//         );
//       });
//     });
//
//     group('deleteToken', () {
//       test('should delete token successfully', () async {
//         // Arrange
//         when(mockStorage.delete(key: Constants.token)).thenAnswer((_) async {});
//
//         // Act
//         await userLocalStorage.deleteToken();
//
//         // Assert
//         verify(mockStorage.delete(key: Constants.token)).called(1);
//       });
//
//       test('should throw exception when delete fails', () async {
//         // Arrange
//         final exception = Exception('Delete error');
//         when(mockStorage.delete(key: Constants.token)).thenThrow(exception);
//
//         // Act & Assert
//         expect(
//               () => userLocalStorage.deleteToken(),
//           throwsA(isA<Exception>().having(
//                 (e) => e.toString(),
//             'message',
//             'Exception: Failed to delete token: $exception',
//           )),
//         );
//       });
//     });
//
//     group('isLoggedIn', () {
//       test('should return true when token exists', () async {
//         // Arrange
//         when(mockStorage.containsKey(key: Constants.token))
//             .thenAnswer((_) async => true);
//
//         // Act
//         final result = await userLocalStorage.isLoggedIn();
//
//         // Assert
//         expect(result, isTrue);
//         verify(mockStorage.containsKey(key: Constants.token)).called(1);
//       });
//
//       test('should return false when token does not exist', () async {
//         // Arrange
//         when(mockStorage.containsKey(key: Constants.token))
//             .thenAnswer((_) async => false);
//
//
//         final result = await userLocalStorage.isLoggedIn();
//
//
//         expect(result, isFalse);
//         verify(mockStorage.containsKey(key: Constants.token)).called(1);
//       });
//
//       test('should throw exception when check fails', () async {
//
//         final exception = Exception('Check error');
//         when(mockStorage.containsKey(key: Constants.token)).thenThrow(exception);
//
//
//         expect(
//               () => userLocalStorage.isLoggedIn(),
//           throwsA(isA<Exception>().having(
//                 (e) => e.toString(),
//             'message',
//             'Exception: Failed to check login status: $exception',
//           )),
//         );
//       });
//     });
//   });
// }