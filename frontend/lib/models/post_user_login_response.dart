import 'package:KakaoTalk/common/common.dart';

class PostUserLoginResponse {
  String? message;
  User? user;
  PostUserLoginResponse({this.message, this.user});

  PostUserLoginResponse.fromJson(Map<String, dynamic> json) {
    message = json.toString();
    user = User.fromJson(json);
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
  String? id;
  String? email;
  String? name;
  String? nickname;
  String? birthday;
  String? bio;
  String? profileimagepath;
  String? profilebackgroundpath;
  bool? isonline;

  User({this.id, this.email, this.name, this.birthday, this.bio, this.profileimagepath});

  void clear() {
    id = null;
    email = null;
    name = null;
    nickname = null;
    birthday = null;
    bio = null;
    profileimagepath = null;
    profilebackgroundpath = null;
    isonline = false;
  }

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    nickname = json['nickname'];
    birthday = json['birthday'];
    //gender = json['gender'];
    bio = json['bio'];
    bio = json['isonline'];

    profileimagepath = json.containsKey('profile_image_path') ? Common.baseUrl + json['profile_image_path'] : null;
    profilebackgroundpath = json.containsKey('profile_background_path') ? Common.baseUrl + json['profile_background_path'] : null;
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
    data['profile_image_path'] = profileimagepath;
    data['profile_background_path'] = profilebackgroundpath;
    data['isonline'] = isonline;
    //data['profile_image_path'] = profileImagePath;
    return data;
  }
}
