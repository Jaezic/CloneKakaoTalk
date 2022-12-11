import 'package:KakaoTalk/models/Chat.dart';

class GetChatsResponse {
  String? message;
  List<Chat>? chats;

  GetChatsResponse.fromJson(Map<String, dynamic> json) {
    message = json.toString();
    chats = [];
    for (var element in (json['datas'] as List)) {
      chats!.add(Chat.fromJson(element));
    }
  }
}
