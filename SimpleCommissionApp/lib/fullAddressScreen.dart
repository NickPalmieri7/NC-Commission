import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'helpScreen.dart';
// Import ResultsScreen

class FullAddressPage extends StatefulWidget {
  const FullAddressPage({super.key});

  @override
  _FullAddressPageState createState() => _FullAddressPageState();
}

class _FullAddressPageState extends State<FullAddressPage> {
  final TextEditingController _addressController = TextEditingController();
  final List<String> _autocompleteSuggestions = [];
  final List<List<String>> _addresses = [];
  List<List<String>> _searchResults = [];
  bool _hasSearched = false;
  bool _showEmptySearchMessage = false;

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  void _fetchAddresses() async {
    final List<String> spreadsheetIds = [
      '1oLgGHNXHSLVy_2Pu2XANr4pIiZzVuGGAFxPcnKXQaEg',
      '1OPPRY_6kgO3rVMF7VjNyTex1NbQ0b6RP3lSa7dXQItM'
    ];
    const String apiKey = 'AIzaSyCimNStnnBIFYVP5LLmvvEP8t_L9TudqHA';
    final List<String> ranges = [
      'APIQueryFiltered!A:J', // For the first spreadsheet
      'CommissionFiltered!A:J' // For the second spreadsheet
    ];

    try {
      for (int i = 0; i < spreadsheetIds.length; i++) {
        final String spreadsheetId = spreadsheetIds[i];
        final String range = ranges[i];
        final Uri uri = Uri.parse(
            'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$range?key=$apiKey');

        final response = await http.get(uri);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['values'] != null) {
            setState(() {
              _addresses.addAll(List<List<String>>.from(
                  data['values'].where((address) {
                    return address.length > 8 && address[8].isNotEmpty;
                  }).map((address) =>
                      List<String>.from(address.map((field) => field.toUpperCase())))));
            });
          }
        } else {
          throw Exception('Failed to fetch data from $spreadsheetId');
        }
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
            .where((address) {
              String formattedAddress = '${address[0]} ${address[1]}, ${address[3]}, ${address[4]}';
              return formattedAddress.contains(query.toUpperCase());
            })
            .map((address) {
              return '${address[0]} ${address[1]}, ${address[3]}, ${address[4]}'; // Format suggestion
            })
            .toList());
      }
    });
  }

void _searchByFullAddress(String fullAddress) {
  if (fullAddress.isEmpty) {
    setState(() {
      _showEmptySearchMessage = true;
      _searchResults = [];
      _hasSearched = false;
    });
    return;
  }

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
    _searchResults = matches.isNotEmpty ? [matches.first] : []; // Only show the first match
    _hasSearched = true;
    _showEmptySearchMessage = false;
  });
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.black,
      title: const Text(
        'Full Address Search',
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        const SizedBox(width: 1),
        IconButton(
          icon: const Icon(Icons.help_outline, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HelpScreen()),
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
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Lighthouse.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              _buildSearchInput(),
              const SizedBox(height: 20),
              ElevatedButton(
  onPressed: () {
    FocusScope.of(context).unfocus(); // Dismiss the keyboard
    _searchByFullAddress(_addressController.text.trim());
  },
  style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
    padding: const EdgeInsets.symmetric(vertical: 15),
    textStyle: const TextStyle(fontSize: 18),
  ),
  child: const Text(
    'Search',
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
  ),
),

              const SizedBox(height: 20),
              if (_showEmptySearchMessage)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    'Please enter an address to search.',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              const SizedBox(height: 20),
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
        const SizedBox(height: 40),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
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
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
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
        const SizedBox(height: 10),
        _buildAutocompleteSuggestions(),
      ],
    );
  }
 Widget _buildOutputContainer() {
  return _hasSearched
      ? _searchResults.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _searchResults.map((result) {
                if (result.length > 8) { // Ensure there is enough data
                  String address = '${result[0]} ${result[1]}';
                  String cityStateZip = '${result[3]}, ${result[4]} ${result[5]}';
                  String commission = result[8];

                  double commissionValue = double.tryParse(commission) ?? 0;
                  bool isLargeNumber = commissionValue > 100;

                  // Adjust font size based on the length of the number
                  double fontSize = commissionValue > 1000 ? 24.0 : (isLargeNumber ? 28.0 : 30.0);
                  TextStyle commissionTextStyle = TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  );

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0), // Decreased vertical margin
                    child: Card(
                      margin: const EdgeInsets.all(0.0), // No margin for the card
                      child: Padding(
                        padding: const EdgeInsets.all(10.0), // Decreased padding
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              address,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0, // Smaller font size
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              cityStateZip,
                              style: const TextStyle(
                                fontSize: 16.0, // Smaller font size
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity, // Fill available width
                              padding: const EdgeInsets.all(10.0), // Smaller padding
                              alignment: Alignment.center,
                              color: commissionValue > 100 ? Colors.green : Colors.blue[700],
                              child: Text(
                                commissionValue > 100 ? '\$${commissionValue.toStringAsFixed(2)}' : '$commission%',
                                style: commissionTextStyle,
                                overflow: TextOverflow.ellipsis, // Handle text overflow
                              ),
                            ),
                          ],
                        ),
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
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 10),
              child: const Text(
                'No results found',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            )
      : const SizedBox.shrink();
}



  Widget _buildAutocompleteSuggestions() {
  return _autocompleteSuggestions.isNotEmpty
      ? Center(
          child: Container(
            margin: const EdgeInsets.only(top: 10.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
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
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              suggestion,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center, // Center text
                            ),
                          ),
                        ),
                        const Divider(height: 1, color: Colors.grey),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        )
      : const SizedBox.shrink();
}
}