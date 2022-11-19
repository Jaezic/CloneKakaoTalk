import 'dart:convert';
import 'dart:io';

import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/common/response.dart';

class Tcp {
  static int timeout = 500;
  static Future<Response> post(String route, {required dynamic data}) async {
    Socket socket = await Socket.connect(Common.serverIP, Common.serverTCPport);

    Map<String, dynamic> message = {"method": "POST", 'route': route, 'data': data};
    var json = jsonEncode(message);
    socket.write(json);

    print('-------------------------------------------------');
    print('[UDP Send]');
    print('IP: ${Common.serverIP} Port#: ${Common.serverUDPport}');
    print('method: ${message['method']}');
    print('route: ${message['route']}');
    print('data:\n' + message['data']);
    print('-------------------------------------------------');
    Response returnObject = Response();
    socket.listen((onData) {
      var json = jsonDecode(String.fromCharCodes(onData));

      print('-------------------------------------------------');
      print('[UDP Receive]');
      print('IP: ${socket.address} Port#: ${socket.port}');
      print('statusCode: ${json['statusCode']} statusMessage: ${json['statusMessage']}');
      print('data:\n${json['data']}');
      print('-------------------------------------------------');
      returnObject = Response(statusCode: json['statusCode'], statusMessage: json['statusMessage'], data: json['data']);
    });
    await Future.delayed(Duration(milliseconds: timeout));
    socket.close();
    if (returnObject.statusCode == null) {
      throw "API 타임 아웃이 발생하였습니다.";
    } else if (returnObject.statusCode != 200) {
      throw "Error ${returnObject.statusCode!} : ${returnObject.statusMessage!}";
    }
    return returnObject;
  }
}
