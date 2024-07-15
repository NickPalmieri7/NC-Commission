import 'package:flutter/material.dart';

class SearchResultsScreen extends StatelessWidget {
  final List<List<String>> searchResults;

  const SearchResultsScreen({Key? key, required this.searchResults}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Black app bar
        centerTitle: true, // Center align the title
        title: Text(
          'Search Results',
          style: TextStyle(
            color: Colors.white, // White lettering
            fontWeight: FontWeight.bold, // Bold text
            fontSize: 24, // Larger font size
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white), // White back arrow
          onPressed: () {
            Navigator.pop(context); // Navigate back when pressed
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Lighthouse.jpg'), // Replace with your image path
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
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final result = searchResults[index];

                    // Ensure result has the expected length before accessing elements
                    if (result.length >= 9) {
                      String address = '${result[0]} ${result[1]}';
                      String cityStateZip = '${result[3]}, ${result[4]} ${result[5]}';
                      String commission = result[8];

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
                                    Text(
                                      cityStateZip,
                                      style: TextStyle(fontSize: 14.0, color: Colors.black54),
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
