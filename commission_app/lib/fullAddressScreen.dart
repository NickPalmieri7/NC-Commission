import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'helpScreen.dart';

class FullAddressPage extends StatefulWidget {
  @override
  _FullAddressPageState createState() => _FullAddressPageState();
}

class _FullAddressPageState extends State<FullAddressPage> {
  TextEditingController _addressController = TextEditingController();
  List<String> _autocompleteSuggestions = [];
  List<List<String>> _addresses = [];
  List<List<String>> _searchResults = [];
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  void _fetchAddresses() async {
    final String spreadsheetId = '1oLgGHNXHSLVy_2Pu2XANr4pIiZzVuGGAFxPcnKXQaEg';
    final String apiKey = 'AIzaSyCimNStnnBIFYVP5LLmvvEP8t_L9TudqHA';
    final String range = 'APIQueryFiltered!A:J'; // Adjusted to include columns A to J

    final Uri uri = Uri.parse(
        'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$range?key=$apiKey');

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['values'] != null) {
          setState(() {
            _addresses = List<List<String>>.from(
                data['values'].map((address) =>
                    List<String>.from(address.map((field) => field.toUpperCase()))));
          });
        }
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _autocompleteAddress(String query) {
    setState(() {
      _autocompleteSuggestions.clear();
      if (query.isNotEmpty) {
        _autocompleteSuggestions.addAll(_addresses
            .where((address) => address.join(' ').contains(query.toUpperCase()))
            .map((address) {
          if (address.length > 4) {
            return '${address[0]} ${address[1]}, ${address[3]}, ${address[4]}'; // Format suggestion
          } else {
            return 'Invalid address format';
          }
        }).toList());
      }
    });
  }

  void _searchByFullAddress(String fullAddress) {
    final matches = _addresses.where((address) {
      if (address.length > 8) { // Adjusted to include up to column I (commission)
        String formattedAddress = '${address[0]} ${address[1]}, ${address[3]}, ${address[4]}';
        String commission = address[8];

        // Check if the formatted address contains the full address query
        bool addressMatch = formattedAddress.toUpperCase().contains(fullAddress.toUpperCase());

        // Include rows where commission is not empty
        if (addressMatch && commission.isNotEmpty) {
          return true;
        } else {
          print('No match: $formattedAddress | Commission: $commission');
          return false;
        }
      } else {
        return false;
      }
    }).toList();

    setState(() {
      _searchResults = matches;
      _hasSearched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Full Address Search',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
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
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Lighthouse.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                _buildSearchInput(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _searchByFullAddress(_addressController.text.trim());
                  },
                  child: Text('Search', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white)),

                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromRGBO(0, 0, 0, 1), // Dark blue
                    padding: EdgeInsets.symmetric(vertical: 20), // Larger padding
                    textStyle: TextStyle(fontSize: 20), // Larger text
                  ),
                ),
                SizedBox(height: 20),
                _buildOutputContainer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 40),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: _addressController,
            onChanged: _autocompleteAddress,
            decoration: InputDecoration(
              hintText: 'Enter Full Address',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _addressController.clear();
                  setState(() {
                    _autocompleteSuggestions.clear();
                  });
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        _buildAutocompleteSuggestions(),
      ],
    );
  }

  Widget _buildAutocompleteSuggestions() {
    return _autocompleteSuggestions.isNotEmpty
        ? Container(
            margin: EdgeInsets.only(top: 10.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _autocompleteSuggestions
                  .map(
                    (suggestion) => Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _addressController.text = suggestion;
                              _autocompleteSuggestions.clear();
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              suggestion,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Divider(height: 1, color: Colors.grey),
                      ],
                    ),
                  )
                  .toList(),
            ),
          )
        : SizedBox.shrink();
  }

  Widget _buildOutputContainer() {
    return _hasSearched
        ? _searchResults.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _searchResults.map((result) {
                  if (result.length > 8) { // Adjusted to include up to column I (commission)
                    String address = '${result[0]} ${result[1]}';
                    String cityStateZip = '${result[3]}, ${result[4]} ${result[5]}';
                    String commission = result[8];

                    double commissionValue = double.tryParse(commission) ?? 0;

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
                                    address,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    cityStateZip,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 80.0,
                              height: 80.0,
                              alignment: Alignment.center,
                              color: commissionValue > 100 ? Colors.green : Colors.blue[700],
                              child: Text(
                                commissionValue > 100 ? '\$${commissionValue.toStringAsFixed(2)}' : '$commission%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: commissionValue > 100 ? 18.0 : 20.0, // Smaller font size for dollar amounts
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }).toList(),
              )
            : Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  'No results found',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              )
        : SizedBox.shrink();
  }
}