import 'package:flutter/material.dart';
import 'helpScreen.dart';

class SearchResultsScreen extends StatelessWidget {
  final List<List<String>> searchResults;

  const SearchResultsScreen({super.key, required this.searchResults});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Black app bar
        centerTitle: true, // Center align the title
        title: const Text(
          'Search Results',
          style: TextStyle(
            color: Colors.white, // White lettering
            fontWeight: FontWeight.bold, // Bold text
            fontSize: 24, // Larger font size
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white), // White back arrow
          onPressed: () {
            Navigator.pop(context); // Navigate back when pressed
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Lighthouse.jpg'), // Background image
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
                searchResults.isEmpty
                    ? Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 10,
                                spreadRadius: 1,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                          child: const Text(
                            'No matching results found.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final result = searchResults[index];

                          // Debug print statements
                          print('Result length: ${result.length}');
                          print('Result data: $result');

                          // Ensure result has the expected length before accessing elements
                          if (result.length >= 9) {
                            String address = '${result[0]} ${result[1]}';
                            String cityStateZip = '${result[3]}, ${result[4]} ${result[5]}';
                            String commissionI = result[8];
                            String commissionJ = result.length > 9 ? result[9] : '';

                            // Determine commission value and format
                            double commissionValue = 0;
                            bool isLargeCommission = false;
                            String displayText = '';

                            if (commissionI.contains('%')) {
                              double commissionPercentage = double.tryParse(commissionI.replaceAll('%', '')) ?? 0;
                              if (commissionPercentage > 100) {
                                commissionValue = commissionPercentage;
                                isLargeCommission = true;
                                displayText = '\$${commissionValue.toStringAsFixed(2)}';
                              } else {
                                displayText = commissionI;
                              }
                            } else {
                              commissionValue = double.tryParse(commissionI) ?? 0;
                              if (commissionValue > 100) {
                                isLargeCommission = true;
                                displayText = '\$${commissionValue.toStringAsFixed(2)}';
                              } else {
                                displayText = commissionI;
                              }
                            }

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            address,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            cityStateZip,
                                            style: const TextStyle(
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
                                      color: isLargeCommission ? Colors.green : Colors.blue[700],
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          displayText,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: displayText.length > 6 ? 14.0 : 20.0, // Adjust font size based on number length
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Container(); // Handle cases where result length is insufficient
                          }
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}