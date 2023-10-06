import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AddDataToFirebase extends StatefulWidget {
  const AddDataToFirebase({super.key});

  @override
  State<AddDataToFirebase> createState() => _AddDataToFirebaseState();
}

class _AddDataToFirebaseState extends State<AddDataToFirebase> {
    final firestoreInstance = FirebaseFirestore.instance;
   TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController applyLinkController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController requirementsController = TextEditingController();
  TextEditingController interviewExperienceController = TextEditingController();
  TextEditingController aboutCompanyController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();



  void _addDataToFirebase() {
    firestoreInstance.collection("jobs").add({
      "title": titleController.text,
      "description": descriptionController.text,
      "requirements": requirementsController.text,
      "aboutCompany": aboutCompanyController.text,
      "imageURL": imageController.text,
      "interviewExperience": interviewExperienceController.text,
      "applyLink": applyLinkController.text,
      "salary": salaryController.text,
      "companyName": companyNameController.text,

    }).then((value) {
      print("Data added to Firestore");
    }).catchError((error) {
      print("Error adding data to Firestore: $error");
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Add Data to Firebase"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            TextFormField(
              controller: requirementsController,
              decoration: InputDecoration(labelText: "requirements"),
            ),
            TextFormField(
              controller: aboutCompanyController,
              decoration: InputDecoration(labelText: "aboutCompany"),
            ),
            TextFormField(
              controller: salaryController,
              decoration: InputDecoration(labelText: "salary"),
            ),
            TextFormField(
              controller: interviewExperienceController,
              decoration: InputDecoration(labelText: "interviewExperience"),
            ),
            TextFormField(
              controller: imageController,
              decoration: InputDecoration(labelText: "Image URL"),
            ),
            TextFormField(
              controller: applyLinkController,
              decoration: InputDecoration(labelText: "Apply Link"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addDataToFirebase,
              child: Text("Add Data to Firebase"),
            ),
          ],
        ),
      ),
    );
  }
}