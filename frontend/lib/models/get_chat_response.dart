import 'package:KakaoTalk/models/Chat.dart';

class GetChatResponse {
  String? message;
  Chat? chat;

  GetChatResponse.fromJson(Map<String, dynamic> json) {
    message = json.toString();
    chat = Chat.fromJson(json);
  }
}
