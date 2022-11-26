import 'dart:convert';
import 'dart:io';

import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/common/response.dart';

class Tcp {
  static int timeout = 1000;
  static Future<Response> post(String route, {required dynamic data}) async {
    Socket? socket;
    Response returnObject = Response();
    Map<String, dynamic> message = {"method": "POST", 'route': route, 'data': data};
    var json = jsonEncode(message);
    await Socket.connect(Common.serverIP, Common.serverTCPport).then((Socket sock) => socket = sock).then((asd) {
      socket!.write("$json\n");
      print('-------------------------------------------------');
      print('[TCP Send]');
      print('IP: ${socket!.remoteAddress} Port#: ${socket!.remotePort}');
      print('method: ${message['method']}');
      print('route: ${message['route']}');
      print('data:\n' + message['data']);
      print('-------------------------------------------------');
      print(json);
      return socket!.first;
    }).then((data) {
      var json = jsonDecode(utf8.decode(data));

      print('-------------------------------------------------');
      print('[TCP Receive]');
      print('IP: ${socket!.address} Port#: ${socket!.port}');
      print('statusCode: ${json['statusCode']} statusMessage: ${json['statusMessage']}');
      print('data:\n${json['data']}');
      print('-------------------------------------------------');
      returnObject = Response(statusCode: json['statusCode'], statusMessage: json['statusMessage'], data: json['data']);
    });

    await socket!.close();
    if (returnObject.statusCode == null) {
      throw "API 타임 아웃이 발생하였습니다.";
    } else if (returnObject.statusCode != 200) {
      throw "Error ${returnObject.statusCode!} : ${returnObject.statusMessage!}";
    }
    return returnObject;
  }
}
