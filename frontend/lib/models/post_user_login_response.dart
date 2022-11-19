class PostUserLoginResponse {
  String? message;
  User? user;
  PostUserLoginResponse({this.message, this.user});

  PostUserLoginResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? email;
  String? name;
  String? nickname;
  String? birthday;
  String? bio;

  User({
    this.id,
    this.email,
    this.name,
    this.birthday,
    this.bio,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    nickname = json['nickname'];
    birthday = json['birthday'];
    //gender = json['gender'];
    bio = json['bio'];
    //profileImagePath = json['profile_image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['nickname'] = nickname;
    data['birthday'] = birthday;
    data['bio'] = bio;
    //data['profile_image_path'] = profileImagePath;
    return data;
  }
}
