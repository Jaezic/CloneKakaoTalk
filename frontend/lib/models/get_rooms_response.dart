import 'package:KakaoTalk/models/get_room_response.dart';

class GetRoomsResponse {
  String? message;
  List<Room>? datas;
  GetRoomsResponse({this.message, this.datas});

  GetRoomsResponse.fromJson(Map<String, dynamic> json) {
    message = json.toString();
    datas = [];
    for (var element in (json['datas'] as List)) {
      datas!.add(Room.fromJson(element));
    }
  }
}

// class lightRoom {
//   String? title;
//   String? roomid;
//   List<lightUser>? users;

//   lightRoom.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     roomid = json['roomid'];
//     users = [];
//     for (var element in (json['users'] as List)) {
//       users!.add(lightUser.fromJson(element));
//     }};
// }

// class lightUser {
//   String? nickname;
//   String? profileimagepath;
//   lightUser.fromJson(Map<String, dynamic> json);
