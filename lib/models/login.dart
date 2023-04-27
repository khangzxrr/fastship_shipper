class LoginModel {
  String token;
  String email;
  String name;

  LoginModel(this.token, this.email, this.name);

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(json['token'], json['email'], json['name']);
  }
}
