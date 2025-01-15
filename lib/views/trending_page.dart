import 'package:flutter/material.dart';

class TrendingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trending Recipes'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Quay lại trang trước
          },
        ),
      ),
      body: Center(
        child: Text(
          'This is Trending Page',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
