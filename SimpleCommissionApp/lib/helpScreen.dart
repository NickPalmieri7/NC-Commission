import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help',
          style: TextStyle(color: Colors.white), // White text color for app bar title
        ),
        backgroundColor: Colors.black, // Black app bar background
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // White back button
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Lighthouse.jpg'), // Background image of lighthouse
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20), // Adjust as needed for spacing
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75, // Adjusted width to match SelectionPage
                  padding: const EdgeInsets.all(12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20), // Curved edges
                    child: AspectRatio(
                      aspectRatio: 1.4, // Enforce square shape
                      child: Image.asset(
                        'assets/THELogo.png', // Your app logo
                        fit: BoxFit.cover, // Crop the image to cover, trimming excess
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Adjust as needed for spacing
              _buildColorBox('Blue Box', 'Indicates commission percentage tied to the address.', 'assets/blueSquare.png'),
              const SizedBox(height: 20), // Adjust as needed for spacing
              _buildColorBox('Green Box', 'Indicates flat compensation for the address.', 'assets/greenBox.png'),
              const SizedBox(height: 20), // Adjust as needed for spacing
              _buildUpdateDelaySection(), // Added new section
              const SizedBox(height: 20), // Adjust as needed for spacing
              _buildDisclaimerSection(), // Disclaimer moved above How To Use section
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorBox(String title, String description, String imagePath) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white, // White box background
        borderRadius: BorderRadius.circular(10.0), // Rounded edges
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
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
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontStyle: FontStyle.italic, 
                    fontFamily: 'DMSans', // Italicized titles
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'DMSans',
                  ), // Normal body text
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateDelaySection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white, // White box background
        borderRadius: BorderRadius.circular(10.0), // Rounded edges
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Update Delay',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontStyle: FontStyle.italic,
              fontFamily: 'DMSans', // Italicized title
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Please note that it may take up to an hour or longer for the property information to display here after being updated on Dotloop.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontFamily: 'DMSans',
            ), // Normal body text
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimerSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white, // White box background
        borderRadius: BorderRadius.circular(10.0), // Rounded edges
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Disclaimer',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontStyle: FontStyle.italic,
              fontFamily: 'DMSans', // Italicized title
            ),
          ),
          SizedBox(height: 10),
          Text(
            'This Information Not Guaranteed. Brokers make an effort to deliver accurate information, but buyers should independently verify any information on which they will rely in a transaction. The listing broker shall not be responsible for any typographical errors, misinformation, or misprints, and they shall be held totally harmless from any damages arising from reliance upon this data.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontFamily: 'DMSans',
            ), // Normal body text
          ),
        ],
      ),
    );
  }
}
