class LoginModel {
  String token;
  String email;
  String roleName;

  LoginModel(this.token, this.email, this.roleName);

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(json['token'], json['email'], json['roleName']);
  }
}
