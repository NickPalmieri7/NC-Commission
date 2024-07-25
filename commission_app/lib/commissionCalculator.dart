import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommissionCalculatorScreen extends StatelessWidget {
  final TextEditingController housePriceController = TextEditingController();
  final TextEditingController commissionPercentageController = TextEditingController();

   @override
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Commission Calculator',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Lighthouse.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/Logo.png',
                    width: 220,
                    height: 220,
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildInputBox(context, 'House Price', housePriceController, TextInputType.number, false),
              SizedBox(height: 20),
              _buildInputBox(context, 'Commission Percentage', commissionPercentageController, TextInputType.numberWithOptions(decimal: true), true),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _calculateCommission(context);
                  },
                  child: Text('Calculate', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 0, 0, 0), 
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


  Widget _buildInputBox(BuildContext context, String label, TextEditingController controller, TextInputType inputType, bool allowDecimal) {
  return Container(
    padding: EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.7),
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 8.0),
        TextField(
          controller: controller,
          keyboardType: inputType,
          textInputAction: TextInputAction.done,
          inputFormatters: allowDecimal
              ? <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ]
              : <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            hintText: 'Enter $label',
          ),
          style: TextStyle(color: Colors.black),
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
          },
        ),
      ],
    ),
  );
}
  void _calculateCommission(BuildContext context) {
    final double housePrice = _parseInput(housePriceController.text);
    final double commissionPercentage = _parseInput(commissionPercentageController.text);
    final double commissionAmount = (housePrice * commissionPercentage) / 100;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: Colors.white, width: 1.0),
          ),
          title: Text(
            'Commission Amount',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.white, width: 1.0),
            ),
            child: Text(
              '\$${_formatNumber(commissionAmount)}',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  double _parseInput(String input) {
    // Remove commas, dollar signs, and percentage symbols, then parse to double
    String sanitizedInput = input.replaceAll(RegExp(r'[,\$%]'), '');
    return double.tryParse(sanitizedInput) ?? 0.0;
  }

  String _formatNumber(double number) {
    return number.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'), (Match match) => ',');
  }
}
