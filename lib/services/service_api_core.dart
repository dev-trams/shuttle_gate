import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shuttle_gate/models/model_core.dart';

class CoreApiService {
  final baseUrl = Uri.parse('http://211.255.23.65/restapi.php');
  Future<List<CoreModel>> fetchCoreData() async {
    print('process started!!:baseUrl[$baseUrl]');
    List<CoreModel> busInstences = [];
    final response = await http
        .get(baseUrl)
        .onError((error, stackTrace) => throw stackTrace);
    print('statusCode: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('process checked! + ${response.body}');
      final List<dynamic> busDataList = jsonDecode(response.body);
      busInstences = busDataList.map((e) => CoreModel.fromJson(e)).toList();
      return busInstences;
    } else {
      print('error');
      throw Exception('Failed to load data');
    }
  }
}
