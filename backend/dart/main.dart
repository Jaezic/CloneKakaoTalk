import 'dart:convert';
import 'dart:io';

import 'package:udp/udp.dart';

void main(List<String> args) async {
  var sender = await UDP.bind(Endpoint.any());
  var tojson = {'method': "POST", 'content': "TEST"};

  var dataLength = await sender.send(jsonEncode(tojson).codeUnits, Endpoint.multicast(InternetAddress("43.200.206.18"), port: Port(9998)));
  print("$dataLength bytes sent.");
}
