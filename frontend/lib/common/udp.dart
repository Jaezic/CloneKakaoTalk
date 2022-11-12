import 'dart:convert';
import 'dart:io';

import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/common/udp_response.dart';
import 'package:udp/udp.dart';

class Udp {
  static Future<Response> post(String method, {required dynamic data}) async {
    Endpoint clinet = Endpoint.any();
    var sender = await UDP.bind(clinet);
    Map<String, dynamic> message = {'method': method, 'data': data};
    var json = jsonEncode(message);

    var dataLength = await sender.send(json.codeUnits, Endpoint.multicast(InternetAddress(Common.serverIP), port: const Port(Common.serverport)));
    print('-------------------------------------------------');
    print('[UDP Send]');
    print('IP: ${Common.serverIP} Port#: ${Common.serverport}');
    print('method: ${message['method']}');
    print('data:\n' + message['data']);
    print('-------------------------------------------------');
    Response returnObject = Response();
    sender.asStream(timeout: const Duration(seconds: 10)).listen((datagram) {
      var json = jsonDecode(String.fromCharCodes(datagram!.data));

      print('-------------------------------------------------');
      print('[UDP Receive]');
      print('IP: ${datagram.address} Port#: ${datagram.port}');
      print('statusCode: ${json['statusCode']} statusMessage: ${json['statusMessage']}');
      print('data:\n${json['data']}');
      print('-------------------------------------------------');
      returnObject = Response(statusCode: json['statusCode'], statusMessage: json['statusMessage'], data: json['data']);
    });
    await Future.delayed(const Duration(seconds: 1));
    sender.close();
    if (returnObject.statusCode == null) throw "API 타임 아웃이 발생하였습니다.";
    return returnObject;
  }
}
