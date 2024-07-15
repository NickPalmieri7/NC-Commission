import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'searchResultsScreen.dart';

class IndividualAddressPage extends StatefulWidget {
  @override
  _IndividualAddressPageState createState() => _IndividualAddressPageState();
}

class _IndividualAddressPageState extends State<IndividualAddressPage> {
  TextEditingController _streetNumberController = TextEditingController();
  TextEditingController _streetNameController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _zipController = TextEditingController();

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
    final String apiKey = 'AIzaSyCimNStnnBIFYVP5LLmvvEP8t_L9TudqHA'; // Replace with your Google Sheets API key
    final String range = 'APIQueryFiltered!A:I'; // Adjust range as per your sheet structure

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
                List<String>.from(address.map((field) => field.toUpperCase())),
              ),
            );
          });
        }
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

void _searchByPartialAddress() {
  final matches = _addresses.where((address) {
    String streetNumber = _streetNumberController.text.trim().toUpperCase();
    String streetName = _streetNameController.text.trim().toUpperCase();
    String city = _cityController.text.trim().toUpperCase();
    String stateInput = _stateController.text.trim().toUpperCase();
    String zip = _zipController.text.trim().toUpperCase();

    // Ensure address has at least 6 elements before accessing indices 0-5
    if (address.length < 6) return false;

    bool matchStreetNumber = streetNumber.isEmpty || address[0].startsWith(streetNumber);
    bool matchStreetName = streetName.isEmpty || address[1].startsWith(streetName);
    bool matchCity = city.isEmpty || address[3].startsWith(city);
    bool matchZip = zip.isEmpty || address[5].startsWith(zip);

    // Match state abbreviation or full state name
    bool matchState = stateInput.isEmpty || _matchesState(stateInput, address[4].toUpperCase());

    return matchStreetNumber && matchStreetName && matchCity && matchState && matchZip;
  }).toList();

  setState(() {
    _searchResults = matches.map((result) {
      // Ensure commission value has '%' appended if missing
      if (result.length > 8) {
        String commission = result[8];
        if (!commission.endsWith('%')) {
          commission = '$commission%'; // Append '%' if not present
          result[8] = commission; // Update the commission value in result
        }
      }
      return result;
    }).toList();
    _hasSearched = true;
  });

  // Navigate to results screen with search results
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SearchResultsScreen(searchResults: _searchResults),
    ),
  );
}

bool _matchesState(String input, String sheetState) {
  // Define mappings for state abbreviations
  Map<String, String> stateAbbreviations = {
    'AL': 'ALABAMA',
    'AK': 'ALASKA',
    'AZ': 'ARIZONA',
    'AR': 'ARKANSAS',
    'CA': 'CALIFORNIA',
    'CO': 'COLORADO',
    'CT': 'CONNECTICUT',
    'DE': 'DELAWARE',
    'FL': 'FLORIDA',
    'GA': 'GEORGIA',
    'HI': 'HAWAII',
    'ID': 'IDAHO',
    'IL': 'ILLINOIS',
    'IN': 'INDIANA',
    'IA': 'IOWA',
    'KS': 'KANSAS',
    'KY': 'KENTUCKY',
    'LA': 'LOUISIANA',
    'ME': 'MAINE',
    'MD': 'MARYLAND',
    'MA': 'MASSACHUSETTS',
    'MI': 'MICHIGAN',
    'MN': 'MINNESOTA',
    'MS': 'MISSISSIPPI',
    'MO': 'MISSOURI',
    'MT': 'MONTANA',
    'NE': 'NEBRASKA',
    'NV': 'NEVADA',
    'NH': 'NEW HAMPSHIRE',
    'NJ': 'NEW JERSEY',
    'NM': 'NEW MEXICO',
    'NY': 'NEW YORK',
    'NC': 'NORTH CAROLINA',
    'ND': 'NORTH DAKOTA',
    'OH': 'OHIO',
    'OK': 'OKLAHOMA',
    'OR': 'OREGON',
    'PA': 'PENNSYLVANIA',
    'RI': 'RHODE ISLAND',
    'SC': 'SOUTH CAROLINA',
    'SD': 'SOUTH DAKOTA',
    'TN': 'TENNESSEE',
    'TX': 'TEXAS',
    'UT': 'UTAH',
    'VT': 'VERMONT',
    'VA': 'VIRGINIA',
    'WA': 'WASHINGTON',
    'WV': 'WEST VIRGINIA',
    'WI': 'WISCONSIN',
    'WY': 'WYOMING',
  };

  // Check if input matches state or abbreviation
  return sheetState == input || stateAbbreviations.containsKey(input) && stateAbbreviations[input] == sheetState;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wide Address Search',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/Lighthouse.jpg',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                _buildInputField('Street Number', _streetNumberController),
                SizedBox(height: 10),
                _buildInputField('Street Name', _streetNameController),
                SizedBox(height: 10),
                _buildInputField('City', _cityController),
                SizedBox(height: 10),
                _buildInputField('State', _stateController),
                SizedBox(height: 10),
                _buildInputField('Zip Code', _zipController),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _searchByPartialAddress,
                  child: Text('Search'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue[800],
                    padding: EdgeInsets.symmetric(vertical: 15),
                    textStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
