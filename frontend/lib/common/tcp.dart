import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/common/response.dart';

class Tcp {
  Socket? connectSocket;
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
      print('data:\n');
      JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      String prettyprint = encoder.convert(message['data']);
      print(prettyprint);
      print('-------------------------------------------------');
      return socket!.first;
    }).then((data) {
      returnObject = receive(data, socket!.address, socket!.port);
    });

    await socket!.close();
    if (returnObject.statusCode == null) {
      throw "API 타임 아웃이 발생하였습니다.";
    } else if (returnObject.statusCode != 200) {
      throw "Error ${returnObject.statusCode!} : ${returnObject.statusMessage!}";
    }
    return returnObject;
  }

  static Future<Response> get(String route, {required dynamic data}) async {
    Socket? socket;
    Response returnObject = Response();
    Map<String, dynamic> message = {"method": "GET", 'route': route, 'data': data};
    var json = jsonEncode(message);
    await Socket.connect(Common.serverIP, Common.serverTCPport).then((Socket sock) => socket = sock).then((asd) {
      socket!.write("$json\n");
      print('-------------------------------------------------');
      print('[TCP Send]');
      print('IP: ${socket!.remoteAddress} Port#: ${socket!.remotePort}');
      print('method: ${message['method']}');
      print('route: ${message['route']}');
      print('data:\n');
      JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      String prettyprint = encoder.convert(message['data']);
      print(prettyprint);
      print('-------------------------------------------------');
      return socket!.first;
    }).then((data) {
      returnObject = receive(data, socket!.address, socket!.port);
    });

    await socket!.close();
    if (returnObject.statusCode == null) {
      throw "API 타임 아웃이 발생하였습니다.";
    } else if (returnObject.statusCode != 200 && returnObject.statusCode != 300) {
      throw "Error ${returnObject.statusCode!} : ${returnObject.statusMessage!}";
    }
    return returnObject;
  }

  static Response receive(Uint8List data, InternetAddress address, int port) {
    var json = jsonDecode(utf8.decode(data));

    print('-------------------------------------------------');
    print('[TCP Receive]');
    print('IP: $address Port#: $port');
    print('statusCode: ${json['statusCode']} statusMessage: ${json['statusMessage']}');
    print('data:\n');
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    String prettyprint = encoder.convert(json['data']);
    print(prettyprint);
    print('-------------------------------------------------');
    return Response(statusCode: json['statusCode'], statusMessage: json['statusMessage'], data: json['data']);
  }

  static Future<Tcp?> connect(String route, {required dynamic data}) async {
    Tcp tcp = Tcp();
    Socket? socket;
    Map<String, dynamic> message = {"method": "CONNECT", 'route': route, 'data': data};
    var json = jsonEncode(message);
    await Socket.connect(Common.serverIP, Common.serverTCPport).then((Socket sock) => socket = sock);
    print('Tcp Connection!');
    socket!.write("$json\n");
    print('-------------------------------------------------');
    print('[TCP Send]');
    print('IP: ${socket!.remoteAddress} Port#: ${socket!.remotePort}');
    print('method: ${message['method']}');
    print('route: ${message['route']}');
    print('data:\n');
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    String prettyprint = encoder.convert(message['data']);
    print(prettyprint);
    print('-------------------------------------------------');
    tcp.connectSocket = socket;
    return tcp;
  }

  void listen(void Function(Uint8List)? onData) async {
    connectSocket!.listen(
      onData,
      onDone: () {
        //socketClose();
      },
    );
  }

  void socketClose() async {
    if (connectSocket != null) {
      await connectSocket!.close();

      connectSocket = null;
      print('Tcp Connection Close!');
      //Common.showSnackBar(messageText: "서버와 연결이 종료되었습니다.");
      //Get.offAll(UserLoginViewPage.url);
    }
  }
}
