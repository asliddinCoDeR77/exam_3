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

  void update({
    String? newName,
    String? newEmail,
    String? newPhone,
    List<String>? newCards,
    String? newSurname,
  }) {
    if (newName != null) name = newName;
    if (newEmail != null) email = newEmail;
    if (newPhone != null) phone = newPhone;
  }

  User copyWith({
    required String name,
    required String email,
    required String phone,
  }) {
    return User(
      id: this.id,
      email: email,
      password: this.password,
      token: this.token,
      expiryDate: this.expiryDate,
      name: name,
      phone: phone,
    );
  }
}
