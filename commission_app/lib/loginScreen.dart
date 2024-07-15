import 'package:flutter/material.dart';
import 'main.dart';

class LoginScreen extends StatelessWidget {
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
                    width: MediaQuery.of(context).size.width * 0.75, // Adjust width as needed
                    height: MediaQuery.of(context).size.width * 0.75, // Ensure it's a square
                    // decoration: BoxDecoration(
                    //   // image: DecorationImage(
                    //   //   image: AssetImage('assets/NCCommissionPhoto.png'),
                    //   //   fit: BoxFit.cover, // Ensure the image covers the entire area
                    //   // ),
                    //   borderRadius: BorderRadius.circular(10), // Add rounded corners if desired
                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: Colors.black.withOpacity(0.4),
                    //       blurRadius: 5,
                    //       offset: Offset(0, 2),
                    //     ),
                    //   ],
                    // ),
                  ),
                  SizedBox(height: 30), // Adjust spacing as needed
                  Container(
                    width: 300,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9), // Semi-transparent white background
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          style: TextStyle(color: Colors.black87), // Text color
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Email or Phone number",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          style: TextStyle(color: Colors.black87), // Text color
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      // Navigate to HomePage after login button is pressed
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black,
                            Colors.black
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      // Add functionality for Forgot Password
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Color.fromRGBO(91, 99, 245, 1)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}