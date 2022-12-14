import 'dart:async';
import 'dart:convert';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/controllers/report_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:illegalparking_app/models/kakao_model.dart';
import 'package:illegalparking_app/utils/alarm_util.dart';
import 'package:illegalparking_app/utils/log_util.dart';

final ReportController reportcontroller = Get.put(ReportController());

Future<Position> searchGPS() async {
  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
}

Future<double> setBearing(double startLatitude, double startLongitude, double endLatitude, double endLongitude) async {
  return Geolocator.bearingBetween(startLatitude, startLongitude, endLatitude, endLongitude);
}

Future<void> setGPS() async {
  Position position = await searchGPS();
  double longitude;
  double latitude;
  if (position.longitude > 1 || position.latitude > 1) {
    longitude = position.longitude;
    latitude = position.latitude;
  } else {
    alertDialogByGetxonebutton("알림", "GPS 위도경도 실패!");
    longitude = 0.0;
    latitude = 0.0;
  }
  reportcontroller.addresswrite(latitude: latitude, longitude: longitude, address: "");
}

Future<void> setAddress({required double latitude, required double longitude}) async {
  await regeocoder(longitude: longitude, latitude: latitude).then((value) => reportcontroller.addresswrite(latitude: latitude, longitude: longitude, address: value));
}

//카카오 경도 위도로 주소
Future<String> regeocoder({required double longitude, required double latitude}) async {
  Kakao map;
  String kakaourl = "https://dapi.kakao.com/v2/local/geo/coord2address.json?x=$longitude&y=$latitude&input_coord=WGS84";

  try {
    final responseGps = await http.get(Uri.parse(kakaourl), headers: {"Authorization": "KakaoAK ${Env.KEY_KAAKAO_RESTAPI}"}).timeout(const Duration(seconds: 2));
    if (responseGps.statusCode == 200) {
      map = Kakao.fromJson(json.decode(responseGps.body));
      String lnmAddr = map.documents[0]['address']['address_name'];
      List<String> temp2 = lnmAddr.split(" ");

      String changeAddr = temp2.first;
      String address = lnmAddr.replaceAll(changeAddr, _getSiName(changeAddr));
      return address;
    } else {
      throw Exception("주소검색 실패!");
    }
  } on TimeoutException catch (_) {
    throw Exception("타임 아웃 오류입니다.");
  } catch (e) {
    alertDialogByGetxonebutton("알림", "카카오맵 실패!");
    Log.debug(e.toString());

    throw Exception("주소검색 실패!");
  }
}

String _getSiName(String si) {
  String result = "";

  switch (si) {
    case "전남":
      result = "전라남도";
      break;
    case "전북":
      result = "전라북도";
      break;
    case "충남":
      result = "충정남도";
      break;
    case "충북":
      result = "충정북도";
      break;
    case "경남":
      result = "경상남도";
      break;
    case "경북":
      result = "경상북도";
      break;
  }

  return result;
}
