import 'dart:convert';
import 'package:exam_3/controllers/services/user_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String id;
  String email;
  final String password;
  final String token;
  final DateTime expiryDate;
  String name;
  String phone;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.token,
    required this.expiryDate,
    required this.name,
    required this.phone,
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
    );
  }

  void update(String newName, String newEmail, String newPhone) {
    name = newName;
    email = newEmail;
    phone = newPhone;
  }
}

class UsersViewmodel {
  User? user;
  final authHttpServices = AuthHttpServices();

  Future<void> register(
      String email, String password, String name, String phone) async {
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
      await sharedPreferences.setString(
        "userData",
        jsonEncode(user!.toMap()),
      );
    } catch (e) {
      String message = e.toString();
      if (message.contains("EMAIL_EXISTS")) {
        message = "Bu email mavjud";
      } else if (message.contains("WEAK_PASSWORD")) {
        message = "Parol juda qisqa!";
      } else if (message.contains("INVALID_EMAIL")) {
        message = "Noto'g'ri email formati";
      }

      throw (message);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      if (!isValidEmail(email)) {
        throw Exception("Invalid email format");
      }

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
      await sharedPreferences.setString(
        "userData",
        jsonEncode(user!.toMap()),
      );
    } catch (e) {
      String message = e.toString();
      if (message.contains("EMAIL_EXISTS")) {
        message = "Bu email mavjud";
      } else if (message.contains("WEAK_PASSWORD")) {
        message = "Parol juda qisqa!";
      } else if (message.contains("INVALID_EMAIL")) {
        message = "Noto'g'ri email formati";
      }

      throw (message);
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

  Future<void> updateUser(String name, String email, String phone) async {
    if (user != null) {
      user!.update(name, email, phone);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString(
        "userData",
        jsonEncode(user!.toMap()),
      );
    }
  }

  User? get currentUser => user;

  Future<void> loadUserFromPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString("userData");

    if (userData != null) {
      user = User.fromMap(jsonDecode(userData));
    }
  }
}
