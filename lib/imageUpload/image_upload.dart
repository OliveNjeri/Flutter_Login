import 'dart:io';

import 'package:flutter/material.dart';
// firebase storage to store uploaded images
import 'package:firebase_storage/firebase_storage.dart';
// image picker to pick images
import 'package:image_picker/image_picker.dart';
// cloud firestore for saving the url of the uploaded  image to our application
import 'package:cloud_firestore/cloud_firestore.dart';

class imageUpload extends StatefulWidget {
  const imageUpload({Key? key}) : super(key: key);

  @override
  _imageUploadState createState() => _imageUploadState();
}

class _imageUploadState extends State<imageUpload> {
  File? image;
  final imagePicker = ImagePicker();

  Future ImagePickerMethod() async {
    // pick image from gallery
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pick != null) {
        image = File(pick.path);
      } else {
        // show a snack bar
        showSnackBar('No file Selected', Duration(milliseconds: 400));
      }
    });
  }

  Future uploadImageMethod() async {
    Reference ref = FirebaseStorage.instance.ref().child('images');
    await ref.putFile(image!);
  }

  // snackbar for showing errors
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sema'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: SizedBox(
                height: 550,
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    const Text('Upload an Image'),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: image == null
                                    ? const Center(
                                        child: Text('No image selected'))
                                    : Image.file(image!),
                              ),
                              ElevatedButton(
                                  child: Text('Select Image'),
                                  onPressed: () {
                                    ImagePickerMethod();
                                  }),
                              ElevatedButton(
                                  child: Text('Upload Image'), onPressed: () {})
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
