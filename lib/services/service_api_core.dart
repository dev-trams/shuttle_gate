import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shuttle_gate/models/model_core.dart';

class CoreApiService {
  final baseUrl =
      Uri.parse('https://jvak.ctrls-studio.com/bus_sample_api.json');
  Future<List<CoreModel>> fetchCoreData() async {
    print('process started!!:baseUrl[$baseUrl]');
    List<CoreModel> busInstences = [];
    final response = await http.get(baseUrl);
    print('data: ${response.statusCode}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> busDatas = jsonDecode(response.body);
      final List<dynamic> bus = busDatas['shuttleCore'];
      for (var busData in bus) {
        busInstences.add(busData);
      }
      return busInstences;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
