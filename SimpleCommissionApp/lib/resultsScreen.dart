import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final List<List<String>> searchResults;

  const ResultsScreen({super.key, required this.searchResults});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Search Results',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: searchResults.map((result) {
                if (result.length > 8) { // Ensure there is enough data
                  String address = '${result[0]} ${result[1]}';
                  String cityStateZip = '${result[3]}, ${result[4]} ${result[5]}';
                  String commission = result[8];

                  double commissionValue = double.tryParse(commission) ?? 0;
                  bool isLargeNumber = commissionValue > 100;

                  // Adjust font size based on the length of the number
                  double fontSize = commissionValue > 1000 ? 24.0 : (isLargeNumber ? 30.0 : 36.0);
                  TextStyle commissionTextStyle = TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  );

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0), // Adjusted vertical margin
                    child: Card(
                      margin: const EdgeInsets.all(0.0), // No margin for the card
                      child: Padding(
                        padding: const EdgeInsets.all(15.0), // Adjusted padding
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              address,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0, // Smaller font size
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              cityStateZip,
                              style: const TextStyle(
                                fontSize: 18.0, // Smaller font size
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              width: double.infinity, // Fill available width
                              padding: const EdgeInsets.all(15.0), // Adjusted padding
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
            ),
          ),
        ],
      ),
    );
  }
}
