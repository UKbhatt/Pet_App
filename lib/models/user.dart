class LoginIn {
  final String email;
  final String password;
  LoginIn(this.email, this.password);

  Map<String, dynamic> toJson() => {"email": email, "password": password};
}
