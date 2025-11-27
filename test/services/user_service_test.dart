import 'package:flutter_test/flutter_test.dart';
import 'package:record/services/user_service.dart';

void main() {
  group('UserService', () {
    test('getUser returns a user', () async {
      final userService = UserService();
      final user = await userService.getUser();
      expect(user, isA<User>());
    });
  });
}
