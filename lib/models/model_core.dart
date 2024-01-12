class CoreModel {
  String? bid;
  String? boardCount;
  String? lat;
  String? lng;

  CoreModel({this.bid, this.boardCount, this.lat, this.lng});

  CoreModel.fromJson(Map<String, dynamic> json) {
    bid = json['bid'];
    boardCount = json['board_count'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bid'] = this.bid;
    data['board_count'] = this.boardCount;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}
