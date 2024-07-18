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
                image: AssetImage('assets/Lighthouse.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                  BlendMode.darken,
                ),
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
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.all(12),
                    child: Image.asset(
                      'assets/Logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 24), // Adjust spacing
                  Text(
                    "Please choose an option:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18, // Adjust font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16), // Adjust spacing
                  _buildSelectionButton(
                    context,
                    'MLS Search',
                    HomePage(initialIndex: 0),
                  ),
                  SizedBox(height: 16), // Adjust spacing
                  _buildSelectionButton(
                    context,
                    'Full Address Search',
                    HomePage(initialIndex: 1),
                  ),
                  SizedBox(height: 16), // Adjust spacing
                  _buildSelectionButton(
                    context,
                    'Partial Address Search',
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
      BuildContext context, String text, Widget page) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75, // Adjust width of selection button container
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withOpacity(0.5), width: 1), // Thin border
        borderRadius: BorderRadius.circular(12), // Rounded corners
        color: Colors.white, // Solid background color
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3), // Shadow offset
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
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
