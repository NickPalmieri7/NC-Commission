import 'package:flutter/material.dart';
import 'mlsScreen.dart';
import 'fullAddressScreen.dart';
import 'wideAddressSearch.dart';
import 'loginScreen.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(), // Initially load LoginPage
      ),
    );

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(8, 14, 128, 1), // Dark blue background
        centerTitle: true, // Center align the title
        title: Text(
          'Login',
          style: TextStyle(
            color: Colors.white, // White lettering
            fontWeight: FontWeight.bold, // Bold text
            fontSize: 24, // Larger font size
          ),
        ),
      ),
      body: LoginScreen(), // Display the login screen
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          MLSPage(), // Left screen with MLS search
          FullAddressPage(), // Middle screen with full address
          IndividualAddressPage(), // Right screen with individual address fields
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(8, 14, 128, 1), // Dark blue background
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update current index on tap
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: 'MLS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.white),
            label: 'Full Address',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city, color: Colors.white),
            label: 'Individual Address',
          ),
        ],
        selectedItemColor: Colors.white, // Color of selected item
        unselectedItemColor: Colors.white.withOpacity(0.6), // Color of unselected items
        showSelectedLabels: true, // Show labels for selected items
        showUnselectedLabels: true, // Show labels for unselected items
        type: BottomNavigationBarType.fixed, // Ensure labels are always visible
        // Define the label text style
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      ),
    );
  }
}

