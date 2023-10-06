class CoreModel {
  final String bid;
  final int boardCount;
  final double x;
  final double y;

  CoreModel.fromJson(Map<String, dynamic> json)
      : bid = json['bid'] ?? 'null',
        boardCount = json['board_count'] ?? 0,
        x = json['map_point']['x'].toDouble() ?? 0,
        y = json['map_point']['y'].toDouble() ?? 0;
}
