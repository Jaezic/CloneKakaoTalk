import 'dart:convert';
import 'dart:io';

import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/common/response.dart';
import 'package:udp/udp.dart';

class Udp {
  static int timeout = 500;
  static Future<Response> post(String route, {required dynamic data}) async {
    Endpoint clinet = Endpoint.any();
    var sender = await UDP.bind(clinet);
    Map<String, dynamic> message = {"method": "POST", 'route': route, 'data': data};
    var json = jsonEncode(message);

    var dataLength = await sender.send(json.codeUnits, Endpoint.multicast(InternetAddress(Common.serverIP), port: const Port(Common.serverUDPport)));
    print('-------------------------------------------------');
    print('[UDP Send]');
    print('IP: ${Common.serverIP} Port#: ${Common.serverUDPport}');
    print('method: ${message['method']}');
    print('route: ${message['route']}');
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
    await Future.delayed(Duration(milliseconds: timeout));
    sender.close();
    if (returnObject.statusCode == null) {
      throw "API 타임 아웃이 발생하였습니다.";
    } else if (returnObject.statusCode != 200) {
      throw "Error ${returnObject.statusCode!} : ${returnObject.statusMessage!}";
    }
    return returnObject;
  }

  static Future<Response> get(String route, {required dynamic data}) async {
    Endpoint clinet = Endpoint.any();
    var sender = await UDP.bind(clinet);
    Map<String, dynamic> message = {"method": "GET", 'route': route, 'data': data};
    var json = jsonEncode(message);

    var dataLength = await sender.send(json.codeUnits, Endpoint.multicast(InternetAddress(Common.serverIP), port: const Port(Common.serverUDPport)));
    print('-------------------------------------------------');
    print('[UDP Send]');
    print('IP: ${Common.serverIP} Port#: ${Common.serverUDPport}');
    print('method: ${message['method']}');
    print('route: ${message['route']}');
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
    await Future.delayed(Duration(milliseconds: timeout));
    sender.close();
    if (returnObject.statusCode == null) {
      throw "API 타임 아웃이 발생하였습니다.";
    } else if (returnObject.statusCode != 200) {
      throw "Error ${returnObject.statusCode!} : ${returnObject.statusMessage!}";
    }
    return returnObject;
  }
}
