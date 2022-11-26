import 'package:ntp/ntp.dart';

// class Dateformat {
//   Timestamp data;
//   Dateformat(this.data);
//   String toDateString() {
//     String date = "알 수 없음";
//     if (Timestamp.now().toDate().difference(data.toDate()).inDays >= 365) {
//       date = '${Timestamp.now().toDate().difference(data.toDate()).inDays ~/ 365}년';
//     } else if (Timestamp.now().toDate().difference(data.toDate()).inDays >= 30) {
//       date = '${Timestamp.now().toDate().difference(data.toDate()).inDays ~/ 30}개월';
//     } else if (Timestamp.now().toDate().difference(data.toDate()).inDays > 0) {
//       date = '${Timestamp.now().toDate().difference(data.toDate()).inDays}일';
//     } else if (Timestamp.now().toDate().difference(data.toDate()).inHours > 0) {
//       date = '${Timestamp.now().toDate().difference(data.toDate()).inHours}시간';
//     } else if (Timestamp.now().toDate().difference(data.toDate()).inMinutes > 0) {
//       date = '${Timestamp.now().toDate().difference(data.toDate()).inMinutes}분';
//     } else {
//       date = '방금';
//     }
//     return date;
//   }
// }

class NTPTime {
  static DateTime? currentTime;

  static Future<DateTime> returnTime() async {
    DateTime time = await NTP.now();
    print(time);

    time.add(const Duration(hours: 9));

    return time;
  }
}
