import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:raindrops_admin/addcategory.dart';
import 'dart:convert';
import 'dart:io';

import 'package:raindrops_admin/api.dart';

class Update_Category extends StatefulWidget {
  final categoryid;
  const Update_Category({super.key, required this.categoryid});

  @override
  State<Update_Category> createState() => _Update_CategoryState();
}

class _Update_CategoryState extends State<Update_Category> {
  TextEditingController categoryname = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  String? _imageUrl; // Variable to hold the image URL

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCategoryDetails();

    print("============================${widget.categoryid}");
  }

  Future<void> fetchCategoryDetails() async {
    try {
      final response = await http.get(Uri.parse("$url/api/category"));

      print("Request URL: $url/api/category");

      if (response.statusCode == 200) {
        final Map<String, dynamic> categoryData = json.decode(response.body);

        print("Response Dataaaaaaaaaaaaaaa: $categoryData");

        if (categoryData.containsKey('data') && categoryData['data'] is List) {
          final category = categoryData['data'].firstWhere(
            (item) => item['_id'] == widget.categoryid,
            orElse: () => null,
          );

          if (category != null) {
            setState(() {
              categoryname.text = category['name'] ?? '';
              _imageUrl = category['image'] != null
                  ? "$url/${category['image']}".replaceAll("public/", "")
                  : null; // Set the image URL
            });
          } else {
            print("Category not found with the given ID");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Category not found')),
            );
          }
        } else {
          print("Invalid response structure: 'data' key is not a list");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid response structure')),
          );
        }
      } else {
        print("Request failed with status: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch category details')),
        );
      }
    } catch (error) {
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }

  Future<void> updateCategory() async {
    if (categoryname.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a category name')),
      );
      return;
    }

    try {
      var slug = categoryname.text.toUpperCase().replaceAll(' ', '-');

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse("$url/api/category-update/${widget.categoryid}"),
      );

      request.fields['name'] = categoryname.text;
      request.fields['slug'] = slug;

      if (_selectedImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            _selectedImage!.path,
          ),
        );
      }

      var response = await request.send();

      // Get the response body
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.green,
              content: Text('Category updated successfully')),
        );

        print("Update response: $responseBody");

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Add_Category()));
      } else {
        print("Update failed with status: ${response.statusCode}");
        print("Response: $responseBody");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update category')),
        );
      }
    } catch (error) {
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Category'),
        backgroundColor: Colors.grey[100],
        elevation: 0,
       
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.person_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Add_Category()));
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                child: Column(
                  children: [
                    TextField(
                      controller: categoryname,
                      decoration: InputDecoration(
                        labelText: 'Category Name',
                        hintText: 'Enter category Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _selectedImage != null
                            ? Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                              )
                            : _imageUrl != null
                                ? Image.network(
                                    _imageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.broken_image,
                                          color: Colors.grey);
                                    },
                                  )
                                : Center(
                                    child: Text(
                                      'Tap to add an image',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // GestureDetector(
                    //   onTap: _pickImage,
                    //   child: Container(
                    //     width: double.infinity,
                    //     height: 200,
                    //     decoration: BoxDecoration(
                    //       border: Border.all(color: Colors.grey),
                    //       borderRadius: BorderRadius.circular(8),
                    //     ),
                    //     child: _selectedImage != null
                    //         ? Image.file(
                    //             _selectedImage!,
                    //             fit: BoxFit.cover,
                    //           )
                    //         : Center(
                    //             child: Text(
                    //               'Tap to add an image',
                    //               style: TextStyle(color: Colors.grey),
                    //             ),
                    //           ),
                    //   ),
                    // ),
                    // SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: updateCategory,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green, // Text color
                        padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12), // Padding for a professional look
                        textStyle: TextStyle(
                          fontSize: 16, // Font size for better readability
                          fontWeight: FontWeight
                              .bold, // Bold font weight for a professional look
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Rounded corners
                        ),
                        elevation:
                            4, // Slight elevation for a subtle shadow effect
                      ),
                      child: Text("Submit"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
