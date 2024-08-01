import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'helpScreen.dart';
import 'commissionCalculator.dart';

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
        backgroundColor: Colors.black,
        title: Text(
          'MLS Search',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.attach_money, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CommissionCalculatorScreen()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.help_outline, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpScreen()),
                  );
                },
              ),
            ],
          ),
        ],
        centerTitle: true,
        automaticallyImplyLeading: false,
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
                          backgroundColor: Colors.black,
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
                      String houseNumber = (row[0] ?? '').replaceAll(',', '');
                      String streetName = (row[1] ?? '').replaceAll(',', '');
                      String city = (row[2] ?? '').replaceAll(',', '');
                      String state = (row[3] ?? '').replaceAll(',', '');
                      String zip = (row[4] ?? '').replaceAll(',', '');
                      String commission = row.length > 8 ? row[8].toString().replaceAll(',', '') : 'N/A';
                      String flatRate = row.length > 9 ? row[9].toString().replaceAll(',', '') : 'N/A';

                      String displayedCommission = commission;
                      Color backgroundColor = Colors.blue;

                      if (flatRate != 'N/A' && double.tryParse(flatRate) != null && double.parse(flatRate) > 100) {
                        displayedCommission = '\$$flatRate';
                        backgroundColor = Colors.green;
                      } else if (commission != 'N/A' && !commission.endsWith('%') && double.tryParse(commission) != null && double.parse(commission) > 100) {
                        displayedCommission = '\$$commission';
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
                                      '$houseNumber $streetName',
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
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'No matching results found.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (_searchResults.isEmpty && _mlsNumberController.text.isEmpty)
                  SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}