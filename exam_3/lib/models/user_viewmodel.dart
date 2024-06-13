import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// User Model
class User {
  final String id;
  final String email;
  final String password;
  final String token;
  final DateTime expiryDate;
  final String name;
  final String phone;
  final String surname;
  final List<String> cards; // Assuming cards are stored as a list of strings

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.token,
    required this.expiryDate,
    required this.name,
    required this.phone,
    required this.surname,
    required this.cards,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'token': token,
      'expiryDate': expiryDate.toIso8601String(),
      'name': name,
      'phone': phone,
      'surname': surname,
      'cards': cards,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      token: map['token'],
      expiryDate: DateTime.parse(map['expiryDate']),
      name: map['name'],
      phone: map['phone'],
      surname: map['surname'],
      cards: List<String>.from(map['cards']),
    );
  }
}

class UsersViewmodel {
  User? user;
  final String firebaseUrl =
      'https://exam-3-6cd7d-default-rtdb.firebaseio.com/users';

  Future<void> register(String email, String password, String name,
      String phone, String surname, List<String> cards) async {
    try {
      if (!isValidEmail(email)) {
        throw Exception("Invalid email format");
      }

      final response = {'localId': 'user123', 'expiresIn': '3600'};

      user = User(
        id: response['localId']!,
        email: email,
        password: password,
        expiryDate: DateTime.now().add(
          Duration(seconds: int.parse(response['expiresIn']!)),
        ),
        name: name,
        phone: phone,
        surname: surname,
        cards: cards,
        token: '',
      );

      final firebaseResponse = await http.post(
        Uri.parse('$firebaseUrl.json'),
        body: jsonEncode(user!.toMap()),
      );

      if (firebaseResponse.statusCode != 200) {
        throw Exception(
            'Failed to send data to Firebase: ${firebaseResponse.body}');
      }

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString("userData", jsonEncode(user!.toMap()));
    } catch (e) {
      String message = e.toString();
      if (message.contains("EMAIL_EXISTS")) {
        message = "This email already exists";
      } else if (message.contains("WEAK_PASSWORD")) {
        message = "The password is too short!";
      } else if (message.contains("INVALID_EMAIL")) {
        message = "Invalid email format";
      }

      print('Error during registration: $message');
      throw Exception(message);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userData = sharedPreferences.getString("userData");

      if (userData == null) {
        throw Exception("No registered user found. Please register first.");
      }

      final storedUser = User.fromMap(jsonDecode(userData));

      if (storedUser.email == email && storedUser.password == password) {
        user = storedUser;
      } else {
        throw Exception("Invalid email or password.");
      }

      if (DateTime.now().isAfter(user!.expiryDate)) {
        throw Exception("Session expired. Please log in again.");
      }
    } catch (e) {
      String message = e.toString();
      if (message.contains("INVALID_EMAIL") ||
          message.contains("INVALID_PASSWORD")) {
        message = "Invalid email or password.";
      }

      print('Error during login: $message');
      throw Exception(message);
    }
  }

  Future<bool> checkLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString("userData");

    if (userData == null) {
      return false;
    }

    user = User.fromMap(jsonDecode(userData));
    return DateTime.now().isBefore(user!.expiryDate);
  }

  bool isValidEmail(String email) {
    RegExp emailValidator = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");
    return emailValidator.hasMatch(email);
  }
}
