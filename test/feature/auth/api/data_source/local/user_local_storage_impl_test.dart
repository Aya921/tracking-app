import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/constants/constants.dart';
import 'package:tracking_app/feature/auth/api/data_source/local/user_local_storage_impl.dart';
import 'user_local_storage_impl_test.mocks.dart';

@GenerateMocks([FlutterSecureStorage])
void main() {
  late MockFlutterSecureStorage mockStorage;
  late UserLocalStorageImpl userLocalStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    userLocalStorage = UserLocalStorageImpl(storage: mockStorage);
  });

  group('UserLocalStorageImpl Tests', () {
    test('saveToken should write token successfully', () async {
      // Arrange
      const token = 'abc123';
      when(mockStorage.write(key: Constants.token, value: token))
          .thenAnswer((_) async {});

      // Act
      await userLocalStorage.saveToken(token);

      // Assert
      verify(mockStorage.write(key: Constants.token, value: token)).called(1);
    });

    test('getToken should return stored token', () async {
      // Arrange
      const token = 'xyz456';
      when(mockStorage.read(key: Constants.token))
          .thenAnswer((_) async => token);

      // Act
      final result = await userLocalStorage.getToken();

      // Assert
      expect(result, equals(token));
      verify(mockStorage.read(key: Constants.token)).called(1);
    });

    test('deleteToken should delete token successfully', () async {
      when(mockStorage.delete(key: Constants.token)).thenAnswer((_) async {});
      await userLocalStorage.deleteToken();
      verify(mockStorage.delete(key: Constants.token)).called(1);
    });

    test('isLoggedIn should return true if key exists', () async {
      when(mockStorage.containsKey(key: Constants.token))
          .thenAnswer((_) async => true);

      final result = await userLocalStorage.isLoggedIn(Constants.token);

      expect(result, isTrue);
      verify(mockStorage.containsKey(key: Constants.token)).called(1);
    });

    test('saveLogin should write rememberMe value', () async {
      const token = 'remember123';
      when(mockStorage.write(key: Constants.rememberMe, value: token))
          .thenAnswer((_) async {});

      await userLocalStorage.saveLoging(token);

      verify(mockStorage.write(key: Constants.rememberMe, value: token))
          .called(1);
    });
  });
}
