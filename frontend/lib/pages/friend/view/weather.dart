import 'dart:convert' as convert;
import 'dart:math' as Math;

import 'package:KakaoTalk/common/format.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Weather {
  Map weatherinfo = {};
  bool error = false;
  double latitude;
  double longitude;

  Weather({required this.latitude, required this.longitude});

  Future<void> weatherInfoGet() async {
    // var currentPosition = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.low);
    // print(currentPosition);
    LatXLngY convertposition = convertGRID_GPS(0, latitude, longitude);
    DateTime now = await NTPTime.returnTime();
    String basedate = DateFormat('yyyyMMdd').format(now);
    String basetime = '';
    print(now.hour);
    if (now.hour > 23) {
      basetime = '${'23'.padLeft(2, '0')}00';
    } else if (now.hour > 20) {
      basetime = '${'20'.padLeft(2, '0')}00';
    } else if (now.hour > 17) {
      basetime = '${'17'.padLeft(2, '0')}00';
    } else if (now.hour > 14) {
      basetime = '${'14'.padLeft(2, '0')}00';
    } else if (now.hour > 11) {
      basetime = '${'11'.padLeft(2, '0')}00';
    } else if (now.hour > 8) {
      basetime = '${'8'.padLeft(2, '0')}00';
    } else if (now.hour > 5) {
      basetime = '${'5'.padLeft(2, '0')}00';
    } else if (now.hour > 2) {
      basetime = '${'2'.padLeft(2, '0')}00';
    } else {
      basedate = (int.parse(basedate) - 1).toString();
      basetime = '2300';
    }
    String x = convertposition.x.toString();
    String y = convertposition.y.toString();

    print(basedate);
    print(basetime);
    print(x);
    print(y);

    final response = await http.get(Uri.parse(
        "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=yEpaye1AMa5uhnwYhnrsE3MnjJlekoDb4%2BTJRVG4NW2%2FdiBLXy7GQv51BLbF8362Mcqgb%2BwGqeDVpfgT7Vgm8Q%3D%3D&pageNo=1&numOfRows=50&dataType=JSON&base_date=$basedate&base_time=$basetime&nx=$x&ny=$y"));
    if (response.statusCode == 200) {
      final json = response.body;
      Map jsonResult = convert.jsonDecode(json);

      print(jsonResult);
      if (!jsonResult.containsKey('response')) {
        error = true;
        print("날씨 정보가 존재하지 않습니다.");
      } else if (!jsonResult['response'].containsKey('body')) {
        error = true;
        print("날씨 정보가 존재하지 않습니다.");
      } else if (!jsonResult['response']['body'].containsKey('items')) {
        error = true;
        print("날씨 정보가 존재하지 않습니다.");
      } else {
        if (now.hour >= 7 && now.hour <= 19) {
          weatherinfo['시간대'] = "낮";
        } else {
          weatherinfo['시간대'] = "밤";
        }
        var item = jsonResult['response']['body']['items']['item'].firstWhere((e) => e['category'] == 'TMP');
        weatherinfo['오늘온도'] = item['fcstValue'].toString();
        item = jsonResult['response']['body']['items']['item'].firstWhere((e) => e['category'] == 'PTY');
        if (item['fcstValue'] == '0') {
          weatherinfo['날씨'] = "화창";
        } else {
          weatherinfo['날씨'] = "비";
        }

        if (item['fcstValue'] == '0') {
          weatherinfo['강수형태'] = "";
        } else if (item['fcstValue'] == '1') {
          weatherinfo['강수형태'] = "비가 오고 ";
        } else if (item['fcstValue'] == '2') {
          weatherinfo['강수형태'] = "비 또는 눈이 오고 ";
        } else if (item['fcstValue'] == '3') {
          weatherinfo['강수형태'] = "눈이 오고 ";
        } else if (item['fcstValue'] == '4') {
          weatherinfo['강수형태'] = "소나기가 오며 ";
        }
        item = jsonResult['response']['body']['items']['item'].firstWhere((e) => e['category'] == 'WSD');
        if (double.parse(item['fcstValue']) < 4) {
          weatherinfo['풍속'] = "바람이 약합니다.";
        } else if (double.parse(item['fcstValue']) < 9) {
          weatherinfo['풍속'] = "바람이 약간 강합니다.";
        } else if (double.parse(item['fcstValue']) < 14) {
          weatherinfo['풍속'] = "바람이 강합니다.";
        } else {
          weatherinfo['풍속'] = "바람이 매우 강합니다.";
        }
        item = jsonResult['response']['body']['items']['item'].firstWhere((e) => e['category'] == 'SKY');
        if (weatherinfo['날씨'] != "비" && weatherinfo['시간대'] == "낮" && (item['fcstValue'] == '4')) weatherinfo['날씨'] = "흐림";
        if (item['fcstValue'] == '1') {
          weatherinfo['하늘형태'] = "하늘이 맑고 ";
        } else if (item['fcstValue'] == '3') {
          weatherinfo['하늘형태'] = "구름이 있고 ";
        } else if (item['fcstValue'] == '4') {
          weatherinfo['하늘형태'] = "흐린 하늘에 ";
        }
        item = jsonResult['response']['body']['items']['item'].firstWhere((e) => e['category'] == 'POP');
        weatherinfo['강수확률'] = item['fcstValue'].toString();
        item = jsonResult['response']['body']['items']['item'].firstWhere((e) => e['category'] == 'REH');
        weatherinfo['습도'] = item['fcstValue'].toString();
        weatherinfo['시간'] = basetime;

        List backgroundName = [];
        if (weatherinfo['시간대'] == "낮") {
          backgroundName.add('d');
        } else {
          backgroundName.add('n');
        }
        if (weatherinfo['날씨'] == "비") {
          backgroundName.add('r');
        } else if (weatherinfo['날씨'] == "흐림") {
          backgroundName.add('b');
        } else {
          backgroundName.add('d');
        }
        String path = backgroundName.join('_');
        if (path == "d_d") {
          path += "_${Math.Random().nextInt(4) + 1}";
        } else if (path == "d_r") {
          path += "_${Math.Random().nextInt(3) + 1}";
        } else if (path == "n_d") {
          path += "_${Math.Random().nextInt(5) + 1}";
        } else if (path == "n_r") {
          path += "_${Math.Random().nextInt(3) + 1}";
        } else if (path == "d_b") {
          path += "_${Math.Random().nextInt(3) + 1}";
        }
        weatherinfo['이미지'] = "$path.jpg";
        print(weatherinfo['이미지']);
        print(weatherinfo);
      }
    } else {
      print("리퀘스트 실패 : ${response.statusCode}");
    }
  }
}

class LatXLngY {
  double? lat;
  double? lng;

  int? x;
  int? y;
}

LatXLngY convertGRID_GPS(int mode, double latX, double lngY) {
  double RE = 6371.00877; // 지구 반경(km)
  double GRID = 5.0; // 격자 간격(km)
  double SLAT1 = 30.0; // 투영 위도1(degree)
  double SLAT2 = 60.0; // 투영 위도2(degree)
  double OLON = 126.0; // 기준점 경도(degree)
  double OLAT = 38.0; // 기준점 위도(degree)
  double XO = 43; // 기준점 X좌표(GRID)
  double YO = 136; // 기1준점 Y좌표(GRID)

  //
  // LCC DFS 좌표변환 ( code : "0"(위경도->좌표, lat_X:위도,  lng_Y:경도), "1"(좌표->위경도,  lat_X:x, lng_Y:y) )
  //

  double DEGRAD = Math.pi / 180.0;
  double RADDEG = 180.0 / Math.pi;

  double re = RE / GRID;
  double slat1 = SLAT1 * DEGRAD;
  double slat2 = SLAT2 * DEGRAD;
  double olon = OLON * DEGRAD;
  double olat = OLAT * DEGRAD;

  double sn = Math.tan(Math.pi * 0.25 + slat2 * 0.5) / Math.tan(Math.pi * 0.25 + slat1 * 0.5);
  sn = Math.log(Math.cos(slat1) / Math.cos(slat2)) / Math.log(sn);
  double sf = Math.tan(Math.pi * 0.25 + slat1 * 0.5);
  sf = Math.pow(sf, sn) * Math.cos(slat1) / sn;
  double ro = Math.tan(Math.pi * 0.25 + olat * 0.5);
  ro = re * sf / Math.pow(ro, sn);
  LatXLngY rs = LatXLngY();

  if (mode == 0) {
    rs.lat = latX;
    rs.lng = lngY;
    double ra = Math.tan(Math.pi * 0.25 + (latX) * DEGRAD * 0.5);
    ra = re * sf / Math.pow(ra, sn);
    double theta = lngY * DEGRAD - olon;
    if (theta > Math.pi) theta -= 2.0 * Math.pi;
    if (theta < -Math.pi) theta += 2.0 * Math.pi;
    theta *= sn;
    rs.x = (ra * Math.sin(theta) + XO + 0.5).floor();
    rs.y = (ro - ra * Math.cos(theta) + YO + 0.5).floor();
  } else {
    rs.x = latX.round();
    rs.y = lngY.round();
    double xn = latX - XO;
    double yn = ro - lngY + YO;
    double ra = Math.sqrt(xn * xn + yn * yn);
    if (sn < 0.0) {
      ra = -ra;
    }
    num alat = Math.pow((re * sf / ra), (1.0 / sn));
    alat = 2.0 * Math.atan(alat) - Math.pi * 0.5;

    double theta = 0.0;
    if (xn.abs() <= 0.0) {
      theta = 0.0;
    } else {
      if (yn.abs() <= 0.0) {
        theta = Math.pi * 0.5;
        if (xn < 0.0) {
          theta = -theta;
        }
      } else {
        theta = Math.atan2(xn, yn);
      }
    }
    double alon = theta / sn + olon;
    rs.lat = alat * RADDEG;
    rs.lng = alon * RADDEG;
  }
  return rs;
}
