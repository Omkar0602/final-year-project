import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class FetchDataFromFirebase extends StatefulWidget {
  @override
  _FetchDataFromFirebaseState createState() => _FetchDataFromFirebaseState();
}

class _FetchDataFromFirebaseState extends State<FetchDataFromFirebase> {
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fetch Data from Firebase"),
      ),
      body: StreamBuilder(
        stream: firestoreInstance.collection("jobs").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var data = snapshot.data!.docs;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var document = data[index];
              return Padding(
                padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                child: Container(
                
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 15,
                        
                      )
                    ],
                  ),
                  padding: EdgeInsets.all(16.0),
                  
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.network(
                          document["imageURL"],
                          width: double.infinity, // Adjust the width as needed
                          height: 200.0, // Adjust the height as needed
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        "Title: ${document["title"]}",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text("Company: ${document["companyName"]}"),
                      Text("Salary: ${document["salary"]}"),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(document: document),
                            ),
                          );
                        },
                        child: Text("View Details"),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final QueryDocumentSnapshot document;

  DetailScreen({required this.document});
  Widget formatInterviewExperiences(String experiences) {
    List<Widget> experienceWidgets = [];
    List<String> paragraphs = experiences.split('\n\n'); // Separate paragraphs

    for (String paragraph in paragraphs) {
      // Replace "\n" with actual newlines
      paragraph = paragraph.replaceAll(r'\n', '\n');

      if (paragraph.startsWith('-')) {
        // If it starts with '-', treat it as bullet points
        List<String> points = paragraph.split('\n- ');
        int pointNumber = 1;

        for (String point in points) {
          if (point.isNotEmpty) {
            experienceWidgets.add(Text("$pointNumber) $point",textAlign: TextAlign.justify,));
            pointNumber++;
          }
        }
      } else {
        // Treat it as a regular paragraph
        experienceWidgets.add(Text(paragraph,textAlign: TextAlign.justify,));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: experienceWidgets,
    );
  }
  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(document["imageURL"]),
              SizedBox(height: 16.0),
              Text(
                "Title: ${document["title"]}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text("Description",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              Text("${document["description"]}",textAlign: TextAlign.justify,),
              
              SizedBox(height: 8.0),
              Text("requirements",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              Text(" ${document["requirements"]}",textAlign: TextAlign.justify,),
              SizedBox(height: 8.0),
              Text("About Company",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              Text(" ${document["aboutCompany"]}",textAlign: TextAlign.justify,),
              SizedBox(height: 8.0),
              
              Text("interview Experience",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
                formatInterviewExperiences(document["interviewExperience"]),
              SizedBox(height: 8.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _launchURL(document["applyLink"]);
                  },
                  child: Text("Apply Link"),
                ),
              ),
              //Text("Apply Link: ${document["applyLink"]}",textAlign: TextAlign.justify,),
            ],
          ),
        ),
      ),
    );
  }
}