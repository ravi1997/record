class User {
  final int id;
  final String name;
  final String email;
  final String employeeId;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.employeeId,
    required this.role,
  });
}

class UserService {
  // Mock user data
  final User _user = User(
    id: 1,
    name: 'John Doe',
    email: 'john.doe@example.com',
    employeeId: 'EMP001',
    role: 'Administrator',
  );

  Future<User> getUser() async {
    // In a real app, this would fetch user data from an API or local storage
    await Future.delayed(const Duration(seconds: 1));
    return _user;
  }
}
