import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help',
          style: TextStyle(color: Colors.white), // White text color for app bar title
        ),
        backgroundColor: Colors.black, // Black app bar background
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white), // White back button
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Lighthouse.jpg'), // Background image of lighthouse
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20), // Adjust as needed for spacing
              Center(
                child: Image.asset(
                  'assets/Logo.png', // Your app logo
                  width: 220, // Increased logo size
                  height: 220,
                ),
              ),
              SizedBox(height: 20), // Adjust as needed for spacing
              _buildColorBox('Blue Box', 'Indicates commission percentage tied to the address.', 'assets/blueSquare.png'),
              SizedBox(height: 20), // Adjust as needed for spacing
              _buildColorBox('Green Box', 'Indicates flat compensation for the address.', 'assets/greenBox.png'),
              SizedBox(height: 20), // Adjust as needed for spacing
              _buildHowToUseSection(),
              SizedBox(height: 20), // Adjust as needed for spacing
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorBox(String title, String description, String imagePath) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white, // White box background
        borderRadius: BorderRadius.circular(10.0), // Rounded edges
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imagePath,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  description,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowToUseSection() {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white, // White box background
        borderRadius: BorderRadius.circular(10.0), // Rounded edges
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How To Use This App',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'This app provides real estate agents with a convenient way to determine their earnings from property sales. Use the MLS search to find properties and view detailed commission information or flat compensation amounts. For address searches, use the autocomplete feature to quickly find properties and their corresponding compensation details.',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}