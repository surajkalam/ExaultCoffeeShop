import 'dart:developer';
import "package:cloud_firestore/cloud_firestore.dart";
import "package:coffee_shop/Features/Home/models/items_model.dart";

import "package:flutter/material.dart";

class Datadstore extends StatefulWidget {
  const Datadstore({super.key});

  @override
  State<Datadstore> createState() => _DatadstoreState();
}

class _DatadstoreState extends State<Datadstore> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController typecontroller = TextEditingController();
  TextEditingController ratingcontroller = TextEditingController();
  TextEditingController imagecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            TextField(
              controller: namecontroller,
              decoration: InputDecoration(hintText: 'itemname'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: typecontroller,
              decoration: InputDecoration(hintText: 'typename'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: ratingcontroller,
              decoration: InputDecoration(hintText: 'rating'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: imagecontroller,
              decoration: InputDecoration(hintText: 'imagelink'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptioncontroller,
              decoration: InputDecoration(hintText: 'description'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: pricecontroller,
              decoration: InputDecoration(hintText: 'price'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                // ignore: unrelated_type_equality_checks
                if (namecontroller.text.isNotEmpty &&
                    typecontroller.text.isNotEmpty &&
                    ratingcontroller.text.isNotEmpty &&
                    imagecontroller.text.isNotEmpty &&
                    descriptioncontroller.text.isNotEmpty &&
                    pricecontroller.text.isNotEmpty) {
                  // Submit to Firebase
                  _submitForm();
                  // namecontroller.clear();
                  // typecontroller.clear();
                  // ratingcontroller.clear();
                  // imagecontroller.clear();
                  // descriptioncontroller.clear();
                  // pricecontroller.clear();
                } else {
                  // Show error if any field is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill all fields'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: EdgeInsets.all(16),
                    ),
                  );
                }
              },
              child: Center(child: Text('submit')),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    // String? category = 'Tea';
    // try {
    //   FirebaseFirestore.instance
    //       .collection('items') // Reference the 'items' collection
    //       .doc(DateTime.now().microsecondsSinceEpoch.toString())
    //       .collection(category) // Create a sub-collection under the document
    //       .add({
    //         'name': namecontroller.text.trim(),
    //         'type': typecontroller.text.trim(),
    //         'rating': double.parse(ratingcontroller.text.trim()),
    //         'image': imagecontroller.text.trim(),
    //         'description': descriptioncontroller.text.trim(),
    //         'price': double.parse(pricecontroller.text.trim()),
    //         'category': category,
    //         'timestamp': FieldValue.serverTimestamp(),
    //       });

    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Item added successfully!'),
    //       backgroundColor: Colors.green,
    //     ),
    //   );
    // } catch (e) {
    //   log('$e');
    // }

    final newItem = Item(
      name: namecontroller.text.trim(),
      type: typecontroller.text.trim(),
      rating: double.parse(ratingcontroller.text.trim()),
      image: imagecontroller.text.trim(),
      description: descriptioncontroller.text.trim(),
      price: double.parse(pricecontroller.text.trim()),
      category: 'Tea',
      timestamp: Timestamp.now(),
    );
    addItem(newItem, customCategory: 'Tea');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item added successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> addItem(Item item, {String? customCategory}) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final String category = customCategory ?? item.category;

      await firestore
          .collection('items')
          // .doc(DateTime.now().microsecondsSinceEpoch.toString())
          .doc('1757264051191711')
          .collection(category)
          .add(item.toMap());

      log('Item added successfully: ${item.name}');
    } catch (e) {
      log('Error adding item: $e');
      rethrow;
    }
  }
}
