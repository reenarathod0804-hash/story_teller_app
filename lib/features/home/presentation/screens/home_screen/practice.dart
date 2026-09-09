import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Practice extends StatefulWidget {
   const Practice({super.key});

  @override
  State<Practice> createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
var category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Category').snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return CircularProgressIndicator();
            }
            var document=snapshot.data!.docs;
            category=document.last;
            return Column(
              children: [
                Text(category['name']),
                Text(category['desc']),
                StreamBuilder(
                    stream:FirebaseFirestore.instance.collection('Story').snapshots() ,
                    builder: (context, snapshot) {
                      if(!snapshot.hasData){
                        return CircularProgressIndicator();
                      }
                      var storyDocument=snapshot.data!.docs;
                      var newStory=storyDocument.where((story)=>story['category_id']==category.id).toList();
                      return Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: newStory.length,
                          itemBuilder: (context, index) {
                          return SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.network(newStory[index]['image']));
                        },),
                      );
                    },)
              ],
            );
          },)
    );
  }
}
