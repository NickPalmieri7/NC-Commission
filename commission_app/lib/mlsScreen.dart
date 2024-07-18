import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'helpScreen.dart';

class MLSPage extends StatefulWidget {
  @override
  _MLSPageState createState() => _MLSPageState();
}

class _MLSPageState extends State<MLSPage> {
  final TextEditingController _mlsNumberController = TextEditingController();
  List<dynamic> _searchResults = [];

  void searchMLS() async {
    final String spreadsheetId = '1oLgGHNXHSLVy_2Pu2XANr4pIiZzVuGGAFxPcnKXQaEg';
    final String apiKey = 'AIzaSyCimNStnnBIFYVP5LLmvvEP8t_L9TudqHA';
    final String range = 'APIQueryFiltered!A:J';

    String mlsNumber = _mlsNumberController.text.trim();
    if (mlsNumber.isEmpty) {
      return;
    }

    final String url = 'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$range?key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> values = data['values'];

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
        title: Text(
          'MLS Search',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/Lighthouse.jpg',
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20.0, 62.0, 20.0, 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 90.0,
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _mlsNumberController,
                          style: TextStyle(fontSize: 18.0, color: Colors.black87),
                          decoration: InputDecoration(
                            hintText: 'Enter an MLS',
                            hintStyle:
                                TextStyle(fontSize: 16.0, color: Color.fromARGB(255, 158, 157, 157)),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () => _mlsNumberController.clear(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      ElevatedButton(
                        onPressed: () {
                          searchMLS();
                        },
                        child: Text('Search', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                          textStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                if (_searchResults.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _searchResults.map((row) {
                      String houseNumber = row[0];
                      String streetName = row[1];
                      String city = row[2];
                      String state = row[3];
                      String zip = row[4];
                      String commission = row.length > 8 ? row[8].toString() : 'N/A';
                      String flatRate = row.length > 9 ? row[9].toString() : 'N/A';

                      String displayedCommission = commission;
                      Color backgroundColor = Colors.blue;

                      if (flatRate != 'N/A' && int.tryParse(flatRate) != null && int.parse(flatRate) > 100) {
                        displayedCommission = '\$$flatRate';
                        backgroundColor = Colors.green;
                      } else {
                        if (!commission.endsWith('%')) {
                          displayedCommission = '$commission%';
                        }
                      }

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$houseNumber $streetName'.replaceAll(',', ''),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black),
                                    ),
                                    Text('$city, $state $zip', style: TextStyle(color: Colors.black54)),
                                  ],
                                ),
                              ),
                              Container(
                                width: 100.0,
                                height: 80.0,
                                alignment: Alignment.center,
                                color: backgroundColor,
                                child: Text(
                                  displayedCommission,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                if (_searchResults.isEmpty && _mlsNumberController.text.isNotEmpty)
                  Text(
                    'No matching results found.',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                if (_searchResults.isEmpty && _mlsNumberController.text.isEmpty)
                  Text(
                    ' ',
                    style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}