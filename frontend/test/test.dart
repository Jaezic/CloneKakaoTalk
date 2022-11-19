import 'dart:io';

void main() async {
  try {
    Socket socket = await Socket.connect("43.200.206.18", 9997);
    socket.write('hello');
    socket.listen((onData) {
      print(String.fromCharCodes(onData));
    });
    await Future.delayed(Duration(seconds: 3));
    socket.close();
  } on Exception catch (e) {
    print(e);
    // TODO
  }
  // TcpSocketConnection socketConnection = TcpSocketConnection("43.200.206.18", 9997);
  // socketConnection.enableConsolePrint(true);
  // await socketConnection.connect(5000, () {});
  // socketConnection.sendMessage("MessageIsReceived :D ");
}
