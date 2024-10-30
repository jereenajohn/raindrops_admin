import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:raindrops_admin/api.dart';
import 'package:raindrops_admin/updatecategory.dart';

class Add_Category extends StatefulWidget {
  const Add_Category({super.key});

  @override
  State<Add_Category> createState() => _Add_CategoryState();
}

class _Add_CategoryState extends State<Add_Category> {
  TextEditingController categoryname = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  List<dynamic> categories = [];

  final String baseUrl =
      "https://expect-devoted-sector-boutique.trycloudflare.com/";

  @override
  void initState() {
    super.initState();
    getcategory();
  }

  Future<void> getcategory() async {
    try {
      final response = await http.get(Uri.parse("$url/api/category"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          categories = responseData['data'].map((category) {
            category['image'] =
                "$baseUrl${category['image']}".replaceAll("public/", "");
            print("Image URL: ${category['image']}");
            return category;
          }).toList();

          print("Categories: $categories");
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch categories')),
        );
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }

  Future<void> addcategory() async {
    if (categoryname.text.isEmpty || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Please provide a category name and select an image')),
      );
      return;
    }

    try {
      var slug = categoryname.text.toUpperCase().replaceAll(' ', '-');
      var request =
          http.MultipartRequest('POST', Uri.parse("$url/api/add-category"));
      request.fields['name'] = categoryname.text;
      request.fields['slug'] = slug;

      var imageFile = await http.MultipartFile.fromPath(
        'image',
        _selectedImage!.path,
      );
      request.files.add(imageFile);

      var response = await request.send();

      final responseBody = await response.stream.bytesToString();
      print(responseBody);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category added successfully')),
        );

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Add_Category()));

        getcategory();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add category')),
        );
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      final response = await http.delete(Uri.parse("$url/api/category/$id"));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category deleted successfully')),
        );
        getcategory(); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete category')),
        );
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }
 void _editCategory(String id) {
  final categoryId = categories.firstWhere((cat) => cat['_id'] == id)['_id'];
  print("Selected Category ID: $categoryId");
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Update_Category(categoryid: categoryId),
    ),
  );
}


 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Category'),
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
                            : Center(
                                child: Text(
                                  'Tap to add an image',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: addcategory,
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
              SizedBox(height: 24),
              Text(
                'Category List',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              DataTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Image')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: categories.map((category) {
                  return DataRow(cells: [
                    DataCell(
                      Text(
                        category['name'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    DataCell(
                      category['image'] != null
                          ? Image.network(
                              category['image'],
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.broken_image,
                                    color: Colors.grey);
                              },
                            )
                          : Container(),
                    ),
                    DataCell(
                      
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.green),
                            onPressed: () => _editCategory(category['_id']),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteCategory(category['_id']),

                          
                          ),
                        ],
                      ),
                    ),
                    
                  ]);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
