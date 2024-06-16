import 'dart:convert';
import 'package:exam_3/controllers/services/user_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UsersViewmodel {
  User? user;
  final String firebaseUrl =
      'https://exam-3-6cd7d-default-rtdb.firebaseio.com/users';
  final authHttpServices = AuthHttpServices();

  Future<void> register(String email, String password, String name,
      String phone, String surname, List<String> cards) async {
    try {
      if (!isValidEmail(email)) {
        throw Exception("Invalid email format");
      }

      final response = await authHttpServices.register(email, password);
      user = User(
        id: response['localId'],
        email: email,
        password: password,
        token: response['idToken'],
        expiryDate: DateTime.now().add(
          Duration(
            seconds: int.parse(response['expiresIn']),
          ),
        ),
        name: name,
        phone: phone,
      );

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString("userData", jsonEncode(user!.toMap()));
    } catch (e) {
      String message = e.toString();
      if (message.contains("EMAIL_EXISTS")) {
        message = "This email already exists.";
      } else if (message.contains("WEAK_PASSWORD")) {
        message = "Password is too weak!";
      } else if (message.contains("INVALID_EMAIL")) {
        message = "Invalid email format.";
      } else {
        message = "An error occurred: $message";
      }
      throw Exception(message);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await authHttpServices.login(email, password);
      user = User(
        id: response['localId'],
        email: email,
        password: password,
        token: response['idToken'],
        expiryDate: DateTime.now().add(
          Duration(
            seconds: int.parse(response['expiresIn']),
          ),
        ),
        name: '',
        phone: '',
      );

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString("userData", jsonEncode(user!.toMap()));
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  bool isValidEmail(String email) {
    RegExp emailValidator = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:.[a-zA-Z0-9-]+)$");
    return emailValidator.hasMatch(email);
  }

  Future<void> loadUserFromPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString("userData");

    if (userData != null) {
      user = User.fromMap(jsonDecode(userData));
    }
  }

  Future<void> saveUserToPreferences(User user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("userData", jsonEncode(user.toMap()));
  }

  Future<void> updateUserOnFirebase(User user) async {
    try {
      final url = '$firebaseUrl/${user.id}.json';
      final response = await http.patch(
        Uri.parse(url),
        body: jsonEncode({
          'name': user.name,
          'email': user.email,
          'phone': user.phone,
        }),
      );

      // Handle response if needed
    } catch (e) {
      throw Exception("Failed to update user on Firebase: $e");
    }
  }

  // Other methods like isValidEmail, etc., remain unchanged based on your initial code

  User? get currentUser => user;
}
