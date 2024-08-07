class RegisterModel {
  String firstName;
  String lastName;
  String email;
  String username;
  bool gender;
  String password;

  RegisterModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.gender,
    required this.password,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      username: json['username'],
      gender: json['gender'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'username': username,
      'gender': gender,
      'password': password,
    };
  }
}
