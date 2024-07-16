import 'package:flutter/material.dart';
import 'main.dart';

class SelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Lighthouse.jpg'), // Replace with your background photo
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.darken), // Add a dark overlay
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10), // Add some padding to the logo container
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3), // Semi-transparent background
                      borderRadius: BorderRadius.circular(10), // Optional: rounded corners for the container
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/Logo.png', // Replace with your logo photo
                      fit: BoxFit.contain, // Adjust to contain the logo without being cut off
                    ),
                  ),
                  SizedBox(height: 20), // Adjust spacing as needed
                  Text(
                    "Please choose an option:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20), // Adjust spacing as needed
                  _buildSelectionButton(
                    context,
                    'MLS Search',
                    Icons.home,
                    HomePage(initialIndex: 0),
                  ),
                  _buildSelectionButton(
                    context,
                    'Full Address Search',
                    Icons.search,
                    HomePage(initialIndex: 1),
                  ),
                  _buildSelectionButton(
                    context,
                    'Partial Address Search',
                    Icons.location_city,
                    HomePage(initialIndex: 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionButton(
      BuildContext context, String text, IconData icon, Widget page) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3), // Semi-transparent background for each box
        borderRadius: BorderRadius.circular(10), // Optional: rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9), // Semi-transparent white background
            borderRadius: BorderRadius.circular(10), // Remove the rounded corners
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: Colors.black),
              SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
