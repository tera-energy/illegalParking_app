class MapInfo {
  Map<String, dynamic>? map;
  String type;
  dynamic data;

  MapInfo(this.type, this.data);

  static MapInfo fromJson(Map<String, dynamic> json) {
    return MapInfo(json["type"], json["data"]);
  }

  String getPkName() {
    return data!["pkName"];
  }

  String getPkAddr() {
    return data!["pkAddr"];
  }

  String getPkPrice() {
    return data!["pkPrice"];
  }

  String getPkOper() {
    return data!["pkOper"];
  }

  int getPkCount() {
    return data!["pkCount"];
  }

  String getPkPhone() {
    return data!["pkPhone"];
  }

  String getPkTime() {
    return data!["pkTime"] ?? "";
  }

  String getPmName() {
    return data!["pmName"];
  }

  int getPmPrice() {
    return data!["pmPrice"];
  }

  String getPmOper() {
    return data!["pmOper"];
  }

  String getPmModel() {
    return data!["pmModel"];
  }

  double getPkLat() {
    return data!["pkLat"];
  }

  double getPkLng() {
    return data!["pkLng"];
  }
}
