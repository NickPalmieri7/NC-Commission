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
        title: Text('Full Address Search'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Full Address',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
    );
  }

  Widget _buildSearchInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _addressController,
          onChanged: _autocompleteAddress,
          decoration: InputDecoration(
            hintText: 'Enter Full Address',
            border: OutlineInputBorder(),
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
        ? Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _searchResults
                  .map(
                    (result) => Text(result.join(', ')),
                  )
                  .toList(),
            ),
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
  }
}