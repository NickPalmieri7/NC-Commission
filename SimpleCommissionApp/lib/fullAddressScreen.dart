import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'helpScreen.dart';

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

  // Method Channel for making phone calls
  static const platform = MethodChannel('com.yourcompany.calls/call');

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    try {
      final String result = await platform.invokeMethod('makeCall', {'phoneNumber': phoneNumber});
      print(result);
    } on PlatformException catch (e) {
      print("Failed to make call: '${e.message}'.");
    }
  }

  void _fetchAddresses() async {
    final List<String> spreadsheetIds = [
      '1oLgGHNXHSLVy_2Pu2XANr4pIiZzVuGGAFxPcnKXQaEg',
      '1OPPRY_6kgO3rVMF7VjNyTex1NbQ0b6RP3lSa7dXQItM'
    ];
    const String apiKey = 'AIzaSyCimNStnnBIFYVP5LLmvvEP8t_L9TudqHA';
    final List<String> ranges = [
      'APIQueryFiltered!A:N', // Adjusted to include columns up to N
      'CommissionFiltered!A:N' // Adjusted to include columns up to N
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
                    return address.length >= 14 && address[8].isNotEmpty; // Ensure enough columns and valid commission
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
      if (address.length >= 14) { // Ensure there is enough data (adjusted to 14 columns)
        String formattedAddress = '${address[0]} ${address[1]}, ${address[3]}, ${address[4]}';
        String commission = address[8];

        // Check if the formatted address contains the full address query
        bool addressMatch = formattedAddress.toUpperCase().contains(fullAddress.toUpperCase());

        if (addressMatch && commission.isNotEmpty) {
          return true;
        } else {
          print('No match: $formattedAddress | Commission: $commission');
          return false;
        }
      } else {
        print('Insufficient data for address.');
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
          'Compensation Search',
          style: TextStyle(color: Colors.white, fontFamily: 'DMSans', fontSize: 16),
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
                      style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'DMSans'),
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
        const SizedBox(height: 20),
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
            onChanged: (value) {
              _autocompleteAddress(value);

              if (value.isEmpty) {
                setState(() {
                  _autocompleteSuggestions.clear();
                  _searchResults.clear();
                  _hasSearched = false;
                  _showEmptySearchMessage = false;
                });
              }
            },
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
                    _searchResults.clear();
                    _hasSearched = false;
                    _showEmptySearchMessage = false;
                  });
                },
              ),
            ),
          ),
        ),
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
                  if (result.length >= 14) { // Ensure there is enough data
                    String address = '${result[0]} ${result[1]}';
                    String cityStateZip = '${result[3]}, ${result[4]} ${result[5]}';
                    String commission = result[8];
                    String agentName = result[12].isNotEmpty ? result[12] : 'No Name Available'; // Column M for agent name
                    String phoneNumber = result[13].isNotEmpty ? result[13] : 'No Phone Number Available'; // Column N for agent phone number

                    // Debugging output
                    print('Address: $address');
                    print('Agent Name: $agentName');
                    print('Phone Number: $phoneNumber');
                    print('Commission: $commission');

                    double commissionValue = double.tryParse(commission) ?? 0;

                    TextStyle defaultTextStyle = const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontFamily: 'DMSans',
                    );

                    TextStyle commissionTextStyle = TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: 'DMSans',
                    );

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Card(
                        margin: const EdgeInsets.all(0.0),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                address,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontFamily: 'DMSans',
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                cityStateZip,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black54,
                                  fontFamily: 'DMSans',
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10.0),
                                alignment: Alignment.center,
                                color: commissionValue > 100 ? Colors.green : Colors.blue[700],
                                child: Text(
                                  commissionValue > 100 ? '\$${commissionValue.toStringAsFixed(2)}' : '$commission%',
                                  style: commissionTextStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 15),
                              // Agent Info Section
                              const Text(
                                'Agent Info',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontFamily: 'DMSans',
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Agent Name: $agentName',
                                style: defaultTextStyle,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (phoneNumber != 'No Phone Number Available') {
                                    _makePhoneCall(phoneNumber);
                                  }
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Phone: ',
                                    style: defaultTextStyle,
                                    children: [
                                      TextSpan(
                                        text: phoneNumber,
                                        style: defaultTextStyle.copyWith(
                                          color: phoneNumber != 'No Phone Number Available' ? Colors.blue : Colors.black,
                                          decoration: TextDecoration.none, // Remove underline
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    // Debugging output if data is not sufficient
                    print('Insufficient data for address.');
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
                  style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'DMSans'),
                ),
              )
        : const SizedBox.shrink();
  }

  Widget _buildAutocompleteSuggestions() {
    return _autocompleteSuggestions.isNotEmpty
        ? Center(
            child: Container(
              margin: const EdgeInsets.only(top: 0.0),
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
                                FocusScope.of(context).unfocus();
                              });
                              _searchByFullAddress(suggestion);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                suggestion,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'DMSans',
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
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