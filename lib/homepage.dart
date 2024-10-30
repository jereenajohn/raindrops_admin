import 'package:flutter/material.dart';
import 'package:raindrops_admin/addcategory.dart';
import 'package:raindrops_admin/addproduct.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                // Handle navigation to home page
                Navigator.pop(context);
              },
            ),
             ListTile(
              leading: Icon(Icons.category),
              title: const Text('Add Category'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Add_Category()));
                // Handle navigation to home page
                // Navigator.pop(context);
              },
            ),
              ListTile(
              leading: Icon(Icons.propane_tank),
              title: const Text('Add Product'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Add_Product()));
                // Handle navigation to home page
                // Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Handle navigation to settings page
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_page),
              title: const Text('Contact Us'),
              onTap: () {
                // Handle navigation to contact page
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: const Text('Welcome to the Home Page!'),
      ),
      
    );
  }
}
