import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleSheetsService {
  final String apiKey;
  final String spreadsheetIds;

  GoogleSheetsService({required this.apiKey, required this.spreadsheetIds});

  Future<List<List<dynamic>>?> fetchData(String range) async {
    try {
      final response = await http.get(
        Uri.parse('https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetIds/values/$range?key=$apiKey'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        List<List<dynamic>>? values = data['values'].map<List<dynamic>>((row) => row.map<dynamic>((cell) => cell).toList()).toList();
        return values;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }
}
