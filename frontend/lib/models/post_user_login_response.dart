class PostUserLoginResponse {
  String? message;
  User? user;
  String? accessToken;
  String? refreshToken;

  PostUserLoginResponse({this.message, this.user, this.accessToken, this.refreshToken});

  PostUserLoginResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    return data;
  }
}

class User {
  int? id;
  String? email;
  String? name;
  String? nickname;
  String? phoneNumber;
  String? birthday;
  String? gender;
  String? bio;
  String? profileImagePath;

  User({this.id, this.email, this.name, this.phoneNumber, this.birthday, this.gender, this.bio, this.nickname});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    nickname = json['nickname'];
    phoneNumber = json['phone_number'];
    birthday = json['birthday'];
    gender = json['gender'];
    bio = json['bio'];
    profileImagePath = json['profile_image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['nickname'] = nickname;
    data['phone_number'] = phoneNumber;
    data['birthday'] = birthday;
    data['gender'] = gender;
    data['bio'] = bio;
    data['profile_image_path'] = profileImagePath;
    return data;
  }
}
