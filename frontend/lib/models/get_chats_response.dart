import 'package:KakaoTalk/models/Chat.dart';

class GetChatsResponse {
  String? message;
  List<Chat>? chats;

  GetChatsResponse.fromJson(Map<String, dynamic> json) {
    message = json.toString();
    chats = [];
    for (Map<String, dynamic> element in (json['datas'] as List)) {
      element["nickname"] = json['users'][element['userid']]['nickname'] ?? '';
      element["profile_image_path"] = json['users'][element['userid']]['profile_image_path'] ?? '';
      chats!.add(Chat.fromJson(element));
    }
  }
}
