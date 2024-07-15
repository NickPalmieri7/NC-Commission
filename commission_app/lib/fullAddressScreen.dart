import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FullAddressPage extends StatefulWidget {
  @override
  _FullAddressPageState createState() => _FullAddressPageState();
}

class _FullAddressPageState extends State<FullAddressPage> {
  TextEditingController _addressController = TextEditingController();
  List<String> _autocompleteSuggestions = [];
  List<List<String>> _addresses = [];
  List<List<String>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  void _fetchAddresses() async {
    final String spreadsheetId = '1oLgGHNXHSLVy_2Pu2XANr4pIiZzVuGGAFxPcnKXQaEg';
    final String apiKey = 'AIzaSyCimNStnnBIFYVP5LLmvvEP8t_L9TudqHA';
    final String range = 'APIQueryFiltered!A:F';

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
            .map((address) => address.join(' '))
            .toList());
      }
    });
  }

  void _searchByFullAddress(String fullAddress) {
  final matches = _addresses.where((address) => address.join(' ').contains(fullAddress.toUpperCase())).toList();
  setState(() {
    _searchResults = matches;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(8, 14, 128, 1),
        title: Text('Full Address Search', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/Lighthouse.jpg',
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Full Address',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 20),
                _buildSearchInput(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _searchByFullAddress(_addressController.text.trim());
                  },
                  child: Text('Search'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromRGBO(57, 137, 201, 1),
                    padding: EdgeInsets.symmetric(vertical: 15),
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
        Container(
          height: 80.0, // Increased height of the search bar container
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8), // Slightly transparent white background
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _addressController,
              onChanged: _autocompleteAddress,
              style: TextStyle(fontSize: 18.0, color: Colors.black87), // Adjusted font size and color
              decoration: InputDecoration(
                hintText: 'Enter Full Address',
                hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey), // Adjusted font size and color
                border: InputBorder.none,
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
        ),
        SizedBox(height: 10),
        _buildAutocompleteSuggestions(),
      ],
    );
  }

  Widget _buildAutocompleteSuggestions() {
    return _autocompleteSuggestions.isNotEmpty
        ? Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _autocompleteSuggestions
                  .map(
                    (suggestion) => InkWell(
                      onTap: () {
                        setState(() {
                          _addressController.text = suggestion;
                          _autocompleteSuggestions.clear();
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(suggestion),
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
        : SizedBox.shrink();
  }



Widget _buildOutputContainer() {
  return _searchResults.isNotEmpty
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _searchResults.map((result) {
            String address = '${result[0]} ${result[1]} ${result[2]} ${result[3]} ${result[4]}';
            String commission = result.length > 8 ? result[8] : 'N/A'; // Access commission at index 8

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
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black),
                          ),
                      
                        ],
                      ),
                    ),
                    Container(
                      width: 80.0,
                      height: 80.0,
                      alignment: Alignment.center,
                      color: Colors.blue[700],
                      child: Text(
                        commission,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        )
      : Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top: 20),
          child: Text('No results found', style: TextStyle(fontSize: 16)),
        );
}}