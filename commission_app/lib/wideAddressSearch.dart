import 'package:flutter/material.dart';
import 'main.dart';

class IndividualAddressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Color.fromRGBO(8, 14, 128, 1), // Dark blue background
      centerTitle: true, // Center align the title
      title: Text(
        'Wide Address Search',
        style: TextStyle(
          color: Colors.white, // White lettering
          fontWeight: FontWeight.bold, // Bold text
          fontSize: 24, // Larger font size
        ),
      ),
    ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Individual Address Fields',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                _buildInputField('Street'),
                SizedBox(height: 10),
                _buildInputField('City'),
                SizedBox(height: 10),
                _buildInputField('Zip Code'),
                SizedBox(height: 10),
                _buildInputField('State'),
              ],
            ),
          ],
        ),
      ),
    );
  }
   Widget _buildInputField(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(7, 17, 212, 0.2),
            blurRadius: 10.0,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        style: TextStyle(color: Color.fromRGBO(7, 17, 212, 1)), // Text color
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}