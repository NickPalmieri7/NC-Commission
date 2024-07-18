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
                    Icons.search,
                    HomePage(initialIndex: 0),
                  ),
                  SizedBox(height: 16), // Adjust spacing
                  _buildSelectionButton(
                    context,
                    'Full Address Search',
                    Icons.search,
                    HomePage(initialIndex: 1),
                  ),
                  SizedBox(height: 16), // Adjust spacing
                  _buildSelectionButton(
                    context,
                    'Partial Address Search',
                    Icons.search,
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
      width: 300, // Adjust width of selection button container
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: Colors.black, size: 24),
              SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
