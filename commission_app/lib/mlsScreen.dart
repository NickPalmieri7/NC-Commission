import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MLSPage extends StatefulWidget {
  @override
  _MLSPageState createState() => _MLSPageState();
}

class _MLSPageState extends State<MLSPage> {
  final TextEditingController _mlsNumberController = TextEditingController();
  List<dynamic> _searchResults = [];

  void searchMLS() async {
    // Replace with your Google Sheets API Key
    final String apiKey = 'AIzaSyCimNStnnBIFYVP5LLmvvEP8t_L9TudqHA';
    // Replace with your Google Sheets Spreadsheet ID
    final String spreadsheetId = '1oLgGHNXHSLVy_2Pu2XANr4pIiZzVuGGAFxPcnKXQaEg';
    final String range = 'APIQueryFiltered!A:I'; // Adjust range as per your sheet structure

    String mlsNumber = _mlsNumberController.text.trim();
    if (mlsNumber.isEmpty) {
      return; // Exit if MLS number is empty
    }

    // Construct the URL for the Google Sheets API
    final String url = 'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$range?key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> values = data['values'];

        // Filter results based on MLS number
        List<dynamic> results = values.where((row) => row.length > 7 && row[7] == mlsNumber).toList();

        setState(() {
          _searchResults = results;
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MLS Search'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _mlsNumberController,
              decoration: InputDecoration(
                hintText: 'Enter MLS Number',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => _mlsNumberController.clear(),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                searchMLS();
              },
              child: Text('Search'),
            ),
            SizedBox(height: 20.0),
            if (_searchResults.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _searchResults.map((row) {
                  String address = row.sublist(0, 6).join(', ');
                  String commission = row.length > 8 ? row[8].toString() : 'Information Unavailable';
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(address),
                      Text('Commission: $commission'),
                      Divider(),
                    ],
                  );
                }).toList(),
              ),
            if (_searchResults.isEmpty && _mlsNumberController.text.isNotEmpty)
              Text('No matching results found.'),
            if (_searchResults.isEmpty && _mlsNumberController.text.isEmpty)
              Text('Enter an MLS number to search.'),
          ],
        ),
      ),
    );
  }
}
