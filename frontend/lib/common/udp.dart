import 'dart:convert';
import 'dart:io';

import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/common/udp_response.dart';
import 'package:udp/udp.dart';

class Udp {
  static Future<Response<T>> post<T>(String method, {required dynamic data}) async {
    Endpoint clinet = Endpoint.any();
    var sender = await UDP.bind(clinet);
    var json = jsonEncode({'method': method, 'data': data});

    var dataLength = await sender.send(json.codeUnits, Endpoint.multicast(InternetAddress(Common.serverIP), port: const Port(Common.serverport)));
    print('UDP : $dataLength bytes sended');
    print(json);
    sender.asStream(timeout: const Duration(seconds: 10)).listen((datagram) {
      var str = String.fromCharCodes(datagram!.data);
      print(jsonDecode(str));
      print(jsonDecode(str));
    });
    await Future.delayed(const Duration(seconds: 5));
    sender.close();
    return Response();
  }
}
